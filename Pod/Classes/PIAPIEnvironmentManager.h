//
//  PIAPIEnvironmentManager.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PIAPIEnvironment.h"

/**
 * User defaults key for API Environment
 * To include environment switching in the Settings bundle, add an item with this key
 * Make sure items are numbered according to the enum defined in PIAPIEnvironment.h
 */
static NSString *const kAPIEnvironmentTypeUserDefaultsIdentifier = @"PIAPIEnvironmentType";

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@required
/**
 *  Required b/c it is mandatory that the session is reset before environments are changed for testing
 *
 *  @param environmentType The PIAPIEnvironmentType that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(PIAPIEnvironmentType)environmentType;

@optional
- (void)environmentManagerDidChangeEnvironment:(PIAPIEnvironmentType)environmentType;

@end

@interface PIAPIEnvironmentManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak)   id <PIAPIEnvironmentManagerDelegate> delegate;
@property (nonatomic, assign) PIAPIEnvironmentType defaultEnvironmentType;
@property (nonatomic, readonly) PIAPIEnvironment *currentEnvironment;
@property (nonatomic, readonly) NSURL *currentEnvironmentURL;

/**
 *  Add a environment to the manager, should be of one type for each DEV, QA, PROD
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environment PIAPIEnvironment to set
 */
- (void)addEnvironment:(PIAPIEnvironment *)environment;

/**
 *  Method to present the UI to change the current environment.
 *  Recommended that this is implemented via the shake feature. (See example project)
 *
 *  @param viewController UIViewController that is presenting the Environment View Controller
 *  @param animated       BOOL of whether the Environment View Controller should be presented with animation
 *  @param completion     The block to execute after the presentation finishes.
 */
- (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                              completion:(void (^)(void))completion;

/**
 *  Returns the baseURL for the specified PIAPIEnvironmentType
 *
 *  @param environmentType PIAPIEnvironmentType to return the baseURL
 *
 *  @return baseURL for specified PIAPIEnvironmentType
 */
- (NSURL *)baseURLForEnvironmentType:(PIAPIEnvironmentType)environmentType;

@end
