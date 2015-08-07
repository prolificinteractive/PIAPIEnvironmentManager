//
//  PIAPIEnvironmentManager.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PIAPIEnvironmentEnums.h"
#import "PIAPIEnvironmentObject.h"

/**
 * User defaults key for API Environment
 * To include environment switching in the Settings bundle, add an item with this key
 * Values should correspond to the enviornment name set in PIAPIEnvironment
 */
extern NSString *const kAPIEnvironmentNameUserDefaultsIdentifier;

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@optional

/**
 *  Method called when the PIAPIEnvironmentManager will change the environment
 *
 *  @param environment The PIAPIEnvironment that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(id<PIAPIEnvironmentObject>)environmentObject;

/**
 *  Method called when the PIAPIEnvironmentManager did change the environment
 *
 *  @param environment The PIAPIEnvironment that was changed to
 */
- (void)environmentManagerDidChangeEnvironment:(id<PIAPIEnvironmentObject>)environmentObject;

@end

@interface PIAPIEnvironmentManager : NSObject

/**
 *  Return the current PIAPIEnvironment that is selected
 *
 *  @return current PIAPIEnvironment
 */
+ (id<PIAPIEnvironmentObject>)currentEnvironment;

/**
 *  Return an array of added environments
 *
 *  @return NSArray of added PIAPIEnvironments
 */
+ (NSArray *)environments;

/**
 *  Return a PIAPIEnvironment from the its name
 *
 *  @param name NSString the name of the environment
 *
 *  @return PIAPIEnvironment from its name. Will return nil if none match
 */
+ (void) setDelegate: (id<PIAPIEnvironmentManagerDelegate>)delegate;

/**
 *  Set the PIAPIEnvironmentInvokeEvent to present the Environment View
 *
 *  @param invokeEvent PIAPIEnvironmentInvokeEvent that will be triggered
 */
+ (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent;

/**
 *  Add an array of environments to the manager
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environments NSArray of PIAPIEnvironments to set
 */
+ (void)addEnvironments:(NSArray *)environments;

/**
 *  Return a PIAPIEnvironment from the its name
 *
 *  @param name NSString the name of the environment
 *
 *  @return PIAPIEnvironment from its name. Will return nil if none match
 */
+ (id<PIAPIEnvironmentObject>)environmentFromName:(NSString *)name;

/**
 *  Method to present the UI to change the current environment
 *
 *  @param viewController UIViewController that is presenting the Environment View Controller
 *  @param animated       BOOL of whether the Environment View Controller should be presented with animation
 *  @param completion     The block to execute after the presentation finishes.
 */
+ (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                              completion:(void (^)(void))completion;

/**
 *  Pushes the default Environment View Controller onto the input navigation controller's view stack.
 *
 *  @param navigationController The navigation controller to present the Environment View Controller.
 *  @param animated             YES if it should be pushed with an animation; otherwise NO.
 */
+ (void)pushEnvironmentViewControllerInNavigationController:(nullable UINavigationController *)navigationController
                                                   animated:(BOOL)animated;

@end
