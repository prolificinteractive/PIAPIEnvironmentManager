//
//  PIAPIEnvironmentManager.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentViewController.h"
#import "PIAPIEnvironmentNavigationController.h"
#import "PIAPIEnvironment.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kAPIEnvironmentNameUserDefaultsIdentifier = @"PIAPIEnvironmentName";

@interface PIAPIEnvironmentManager () <PIAPIEnvironmentViewDelegate> {
    PIAPIEnvironment *_currentEnvironment;
}

@property (nonatomic, strong) NSMutableArray *environments;
@property (nonatomic, strong) PIAPIEnvironmentNavigationController *environmentViewNavController;
@property (nonatomic, strong) PIAPIEnvironmentViewController *environmentViewController;
@property (nonatomic, strong) PIAPIEnvironment *currentEnvironment;

@property (nonatomic, strong) UIWindow *environmentWindow;

@property (nonatomic, weak) UIWindow *mainWindow;
@property (nonatomic, weak) id <PIAPIEnvironmentManagerDelegate> delegate;


@property (nonatomic, assign) PIAPIEnvironmentInvokeEvent invokeEvent;

@end

@implementation PIAPIEnvironmentManager

+ (instancetype)sharedManager {
    static PIAPIEnvironmentManager *environmentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        environmentManager = [PIAPIEnvironmentManager new];
    });
    return environmentManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.environments = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark - Custom Accessors

- (UIWindow *)mainWindow {
    if (!_mainWindow) {
         _mainWindow = [[[UIApplication sharedApplication] delegate] window];
    }
    return _mainWindow;
}

- (UIWindow *)environmentWindow
{
    if (!_environmentWindow) {
        _environmentWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_environmentWindow setWindowLevel:UIWindowLevelNormal];

        //if it desired not to present manually, add to its own window
        if (self.invokeEvent != PIAPIEnvironmentInvokeEventNone){
            _environmentWindow.rootViewController = self.environmentViewNavController;
            [_environmentWindow addSubview:self.environmentViewNavController.view];
        }
    }
    [_environmentWindow makeKeyAndVisible];
    return _environmentWindow;
}

- (PIAPIEnvironmentNavigationController *)environmentViewNavController {
    if (!_environmentViewNavController) {
        _environmentViewNavController = [[PIAPIEnvironmentNavigationController alloc] initWithRootViewController:self.environmentViewController];
    }
    return _environmentViewNavController;
}

- (PIAPIEnvironmentViewController *)environmentViewController {
    if (!_environmentViewController) {
        _environmentViewController = [PIAPIEnvironmentViewController new];
        _environmentViewController.environments = self.environments;
        _environmentViewController.delegate = self;
    }
    _environmentViewController.currentEnvironment = self.currentEnvironment;
    return _environmentViewController;
}

- (PIAPIEnvironment *)currentEnvironment {
    if (!_currentEnvironment) {
        _currentEnvironment = [self environmentFromUserDefaults];
    }
    return _currentEnvironment;
}

- (void)setCurrentEnvironment:(PIAPIEnvironment *)currentEnvironment
{
    if (_currentEnvironment == currentEnvironment) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(environmentManagerWillChangeEnvironment:)]) {
        [self.delegate environmentManagerWillChangeEnvironment:currentEnvironment];
    }

    _currentEnvironment = currentEnvironment;

    if ([self.delegate respondsToSelector:@selector(environmentManagerDidChangeEnvironment:)]) {
        [self.delegate environmentManagerDidChangeEnvironment:currentEnvironment];
    }

    [self setUserDefaultsEnvironment:currentEnvironment];
}

#pragma mark - User Defaults

- (NSString *)environmentNameFromUserDefaults
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentNameUserDefaultsIdentifier];
}
        
- (PIAPIEnvironment *)environmentFromUserDefaults
{
    return [PIAPIEnvironmentManager environmentFromName:[self environmentNameFromUserDefaults]];
}

- (void)setUserDefaultsEnvironment:(PIAPIEnvironment *)environment
{
    if (![[self environmentNameFromUserDefaults] isEqualToString:environment.name]) {
        [[NSUserDefaults standardUserDefaults] setObject:environment.name
                                                  forKey:kAPIEnvironmentNameUserDefaultsIdentifier];
    }
}

#pragma mark - Public Methods

+ (PIAPIEnvironment *)currentEnvironment
{
    return [PIAPIEnvironmentManager sharedManager].currentEnvironment;
}

+ (NSURL *)currentEnvironmentURL
{
    return [PIAPIEnvironmentManager sharedManager].currentEnvironment.baseURL;
}

+ (NSArray *)environments
{
    return [[PIAPIEnvironmentManager sharedManager].environments copy];
}

+ (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent
{
    PIAPIEnvironmentManager *sharedManager = [PIAPIEnvironmentManager sharedManager];
    sharedManager.invokeEvent = invokeEvent;

    if (invokeEvent == PIAPIEnvironmentInvokeEventShake) {
        __block IMP originalIMP = PIReplaceMethodWithBlock([UIWindow class], @selector(motionEnded:withEvent:), ^(UIWindow *_self, UIEventSubtype motion, UIEvent *event) {
            if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
                [sharedManager showEnvironmentView];
            }

            ((void (*)(id, SEL, UIEventSubtype, UIEvent *))originalIMP)(_self, @selector(motionEnded:withEvent:), motion, event);
        });
    }
    else if (invokeEvent == PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft) {
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showEnvironmentView)];
        swipeGesture.numberOfTouchesRequired = 2;
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [sharedManager.mainWindow addGestureRecognizer:swipeGesture];
    }
}

+ (void)setDelegate:(id<PIAPIEnvironmentManagerDelegate>)delegate
{
    [PIAPIEnvironmentManager sharedManager].delegate = delegate;
}

+ (void)addEnvironment:(PIAPIEnvironment *)environment
{
    PIAPIEnvironmentManager *sharedManager = [PIAPIEnvironmentManager sharedManager];
    [sharedManager.environments addObject:environment];

    if (environment.isDefault) {
        //The defaultEnvironmentType is not saved if we have a stored environment to remember last environment
        if (!sharedManager.currentEnvironment){
            sharedManager.currentEnvironment = environment;
        }
    }
}

+ (void)addEnvironments:(NSArray *)environments
{
    [[PIAPIEnvironmentManager sharedManager].environments addObjectsFromArray:environments];
}

+ (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                             completion:(void (^)(void))completion
{
    [viewController presentViewController:[PIAPIEnvironmentManager sharedManager].environmentViewNavController
                                          animated:animated
                                         completion:completion];
}

+ (void)pushEnvironmentViewControllerInNavigationController:(UINavigationController *)navigationController
                                                   animated:(BOOL)animated
{
    [navigationController pushViewController:[PIAPIEnvironmentManager sharedManager].environmentViewController
                                    animated:animated];
}

+ (PIAPIEnvironment *)environmentFromName:(NSString *)name
{
    for (PIAPIEnvironment *environment in [PIAPIEnvironmentManager sharedManager].environments) {
        if ([name isEqualToString:environment.name]) {
            return environment;
        }
    }
    return nil;
}

#pragma mark - Notifications

- (void)userDefaultsDidChange
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentEnvironment = [self environmentFromUserDefaults];
}

#pragma mark - Private Methods

+ (void)showEnvironmentView
{
    [[PIAPIEnvironmentManager sharedManager] showEnvironmentView];
}

- (void)showEnvironmentView
{
    CGRect originalFrame = self.environmentWindow.frame;
    originalFrame.origin.y += originalFrame.size.height;
    self.environmentViewNavController.view.frame = originalFrame;

    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         self.environmentViewNavController.view.frame = _environmentWindow.frame;
                     } completion:nil];
}

- (void)dismissEnvironmentView {
    CGRect animatedFrame = self.environmentWindow.frame;
    animatedFrame.origin.y += self.environmentWindow.frame.size.height;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         self.environmentViewNavController.view.frame = animatedFrame;
                     } completion: ^(BOOL finished) {
                         self.environmentWindow.hidden = YES;
                     }];
}

#pragma mark - PIAPIEnvironmentViewDelegate Methods

- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironment *)environment
{
    self.currentEnvironment = environment;
}

- (void)environmentViewDoneButtonPressed:(id)sender
{
    if (self.invokeEvent == PIAPIEnvironmentInvokeEventNone){
        [self.environmentViewNavController.presentingViewController dismissViewControllerAnimated:YES
                                                                                       completion:nil];
    } else {
        [self dismissEnvironmentView];
    }

}

#pragma mark - Swizzled Methods

/**
 *  Method to use for swizzling
 *  Reference: http://petersteinberger.com/blog/2014/a-story-about-swizzling-the-right-way-and-touch-forwarding/
 *
 *  @param aClass  Class that will be overriding the original selector
 *  @param origSEL original selector that will be overiding
 *  @param block   Block to trigger in place of original selector
 */
static IMP PIReplaceMethodWithBlock(Class aClass, SEL origSEL, id block)
{
    NSCParameterAssert(block);

    // get original method
    Method origMethod = class_getInstanceMethod(aClass, origSEL);
    NSCParameterAssert(origMethod);

    // convert block to IMP trampoline and replace method implementation
    IMP newIMP = imp_implementationWithBlock(block);

    // Try adding the method if not yet in the current class
    if (!class_addMethod(aClass, origSEL, newIMP, method_getTypeEncoding(origMethod))) {
        return method_setImplementation(origMethod, newIMP);
    }
    else {
        return method_getImplementation(origMethod);
    }
}

@end
