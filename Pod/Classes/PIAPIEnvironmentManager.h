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
#import "PIAPIEnvironment.h"

/**
 * User defaults key for API Environment
 * To include environment switching in the Settings bundle, add an item with this key
 * Make sure items are numbered according to the enum defined in PIAPIEnvironment.h
 */
extern NSString *const kAPIEnvironmentTypeUserDefaultsIdentifier;

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@optional
/**
 *  Method called when the PIAPIEnvironmentManager will change the environment
 *
 *  @param environment The PIAPIEnvironment that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(PIAPIEnvironment *)environment;
/**
 *  Method called when the PIAPIEnvironmentManager did change the environment
 *
 *  @param environment The PIAPIEnvironment that was changed to
 */
- (void)environmentManagerDidChangeEnvironment:(PIAPIEnvironment *)environment;

@end

@interface PIAPIEnvironmentManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readwrite, weak)   id <PIAPIEnvironmentManagerDelegate> delegate;

@property (nonatomic, readonly, strong) PIAPIEnvironment *currentEnvironment;
@property (nonatomic, readonly, strong) NSURL *currentEnvironmentURL;

/**
 *  Set the PIAPIEnvironmentInvokeEvent to present the Environment View
 *
 *  @param invokeEvent PIAPIEnvironmentInvokeEvent that will be triggered
 */
- (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent;

/**
 *  Add a environment to the manager
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environment PIAPIEnvironment to set
 */
- (void)addEnvironment:(PIAPIEnvironment *)environment;

/**
 *  Return a PIAPIEnvironment from the its name
 *
 *  @param name NSString the name of the environment
 *
 *  @return PIAPIEnvironment from its name. Will return nil if none match
 */
- (PIAPIEnvironment *)environmentFromName:(NSString *)name;

/**
 *  Method to present the UI to change the current environment
 *
 *  @param viewController UIViewController that is presenting the Environment View Controller
 *  @param animated       BOOL of whether the Environment View Controller should be presented with animation
 *  @param completion     The block to execute after the presentation finishes.
 */
- (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                              completion:(void (^)(void))completion;

@end
