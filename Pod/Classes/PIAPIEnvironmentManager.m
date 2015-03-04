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

static NSString *const kAPIEnvironmentManagerIdentifier = @"APIEnvironmentManager";

@interface PIAPIEnvironmentManager () <PIAPIEnvironmentViewDelegate> {
    PIAPIEnvironment *_currentEnvironment;
}

@property (nonatomic, strong) NSMutableArray *environments;
@property (nonatomic, strong) PIAPIEnvironmentNavigationController *environmentViewNavController;
@property (nonatomic, strong) PIAPIEnvironmentViewController *environmentViewController;
@property (nonatomic, strong) PIAPIEnvironment *currentEnvironment;

@property (nonatomic, strong) UIWindow *environmentWindow;
@property (nonatomic, weak) UIWindow *mainWindow;

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
    }
    return self;
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
        _environmentWindow.rootViewController = self.environmentViewNavController;
        [_environmentWindow addSubview:self.environmentViewNavController.view];
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
        NSString *baseUrlString = [[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentManagerIdentifier];
        _currentEnvironment = [self environmentFromBaseURLString:baseUrlString];
    }
    return _currentEnvironment;
}

- (void)setCurrentEnvironment:(PIAPIEnvironment *)currentEnvironment
{
    _currentEnvironment = currentEnvironment;
    [[NSUserDefaults standardUserDefaults] setObject:currentEnvironment.baseURL.absoluteString
                                              forKey:kAPIEnvironmentManagerIdentifier];
}

- (NSURL *)currentEnvironmentURL
{
    return self.currentEnvironment.baseURL;
}

#pragma mark - Public Methods

- (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent {
    if (invokeEvent == PIAPIEnvironmentInvokeEventShake) {
        __block IMP originalIMP = PIReplaceMethodWithBlock([UIWindow class], @selector(motionEnded:withEvent:), ^(UIWindow *_self, UIEventSubtype motion, UIEvent *event) {
            if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
                [self showEnvironmentView];
            }

            ((void (*)(id, SEL, UIEventSubtype, UIEvent *))originalIMP)(_self, @selector(motionEnded:withEvent:), motion, event);
        });
    }
    else if (invokeEvent == PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft) {
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showEnvironmentView)];
        swipeGesture.numberOfTouchesRequired = 2;
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.mainWindow addGestureRecognizer:swipeGesture];
    }
}

- (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                             completion:(void (^)(void))completion {
      [viewController presentViewController:self.environmentViewNavController
                                          animated:animated
                                         completion:completion];
}

#pragma mark - Private Methods

- (void)showEnvironmentView {
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

- (void)addEnvironment:(PIAPIEnvironment *)environment {
    [self.environments addObject:environment];

    if (environment.isDefault) {
       //The defaultEnvironmentType is not saved if we have a stored environment to remember last environment
        if (!self.currentEnvironment){
             self.currentEnvironment = environment;
        }
    }
}

- (PIAPIEnvironment *)environmentFromBaseURLString:(NSString *)baseURLString
{
    for (PIAPIEnvironment *environment in self.environments) {
        if ([baseURLString isEqualToString:environment.baseURL.absoluteString]) {
            return environment;
        }
    }
    return nil;
}

#pragma mark - PIAPIEnvironmentViewDelegate Methods

- (void)environmentViewWillChangeEnvironment:(PIAPIEnvironment *)environment {
    if ([self.delegate respondsToSelector:@selector(environmentManagerWillChangeEnvironment:)]) {
        [self.delegate environmentManagerWillChangeEnvironment:environment];
    }
}

- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironment *)environment {
    if (self.currentEnvironment != environment) {
        self.currentEnvironment = environment;
    }

    if ([self.delegate respondsToSelector:@selector(environmentManagerDidChangeEnvironment:)]) {
        [self.delegate environmentManagerDidChangeEnvironment:environment];
    }
}

- (void)environmentViewDoneButtonPressed:(id)sender {
    [self dismissEnvironmentView];
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
static IMP PIReplaceMethodWithBlock(Class aClass, SEL origSEL, id block) {
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
