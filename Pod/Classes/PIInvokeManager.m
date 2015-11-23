//
//  PIInvokeManager.m
//  Pods
//
//  Created by Christopher Jones on 9/12/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

#import "PIInvokeManager.h"
#import "PIAPIEnvironmentViewController.h"
#import "PIAPIEnvironmentNavigationController.h"

#import <objc/runtime.h>
#import <objc/message.h>

static IMP PIReplaceMethodWithBlock(Class aClass, SEL origSEL, id block);

@interface PIInvokeManager () <PIAPIEnvironmentViewDelegate>

@property (nullable, nonatomic, strong) PIAPIEnvironmentManager *environmentManager;
@property (nonatomic, assign) PIAPIEnvironmentInvokeEvent invokeEvent;


@property (nonatomic, strong) UIWindow *environmentWindow;
@property (nonatomic, weak, readonly) UIWindow *mainWindow;

@end

@implementation PIInvokeManager

+ (nonnull instancetype)sharedManager
{
    static PIInvokeManager *manager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[PIInvokeManager alloc] init];
    });

    return manager;
}

+ (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent
            forManager:(PIAPIEnvironmentManager *)environmentManager
{
    PIInvokeManager *manager = [PIInvokeManager sharedManager];

    manager.invokeEvent = invokeEvent;
    manager.environmentManager = environmentManager;

    if (invokeEvent == PIAPIEnvironmentInvokeEventShake) {
        __block IMP originalIMP = PIReplaceMethodWithBlock([UIWindow class], @selector(motionEnded:withEvent:), ^(UIWindow *_self, UIEventSubtype motion, UIEvent *event) {
            if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
                [manager showEnvironmentView];
            }

            ((void (*)(id, SEL, UIEventSubtype, UIEvent *))originalIMP)(_self, @selector(motionEnded:withEvent:), motion, event);
        });
    }
    else if (invokeEvent == PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft) {
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:manager action:@selector(showEnvironmentView)];
        swipeGesture.numberOfTouchesRequired = 2;
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [manager.mainWindow addGestureRecognizer:swipeGesture];
    } else {
        manager.environmentManager = nil;
    }
}


- (void)showEnvironmentView
{
    self.environmentWindow.alpha = 0.0f;
    [self.environmentWindow makeKeyAndVisible];

    [UIView animateWithDuration:0.2f animations:^{
        self.environmentWindow.alpha = 1.0f;
    }];
}

- (void)dismissEnvironmentView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.environmentWindow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.environmentWindow.hidden = YES;
    }];
}

#pragma mark - PIAPIEnvironmentViewDelegate Methods

- (void)environmentViewDoneButtonPressed:(PIAPIEnvironmentViewController *)sender
{
    if (self.invokeEvent == PIAPIEnvironmentInvokeEventNone) {
        [sender dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissEnvironmentView];
    }
}

- (UIWindow *)mainWindow
{
    return [[UIApplication sharedApplication] delegate].window;
}

- (UIWindow *)environmentWindow
{
    if (!_environmentWindow) {
        _environmentWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_environmentWindow setWindowLevel:UIWindowLevelNormal];

        _environmentWindow.rootViewController = [self generateEnvironmentViewControllerStack];
        [_environmentWindow addSubview:_environmentWindow.rootViewController.view];
    }
    
    [_environmentWindow makeKeyAndVisible];
    return _environmentWindow;
}

- (PIAPIEnvironmentNavigationController * _Nonnull)generateEnvironmentViewControllerStack
{
    PIAPIEnvironmentViewController *environmentViewController = [[PIAPIEnvironmentViewController alloc] initWithEnvironmentManager:self.environmentManager];
    environmentViewController.delegate = self;
    PIAPIEnvironmentNavigationController *navigationController = [[PIAPIEnvironmentNavigationController alloc] initWithRootViewController:environmentViewController];

    return navigationController;
}


@end


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
