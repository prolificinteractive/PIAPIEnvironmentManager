//
//  PIAPIEnvironmentManager.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PIEnums.h"
#import "PIAPIEnvironment.h"

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@optional
/**
 *  Method called when the PIAPIEnvironmentManager will change the environment
 *
 *  @param environmentType The PIAPIEnvironmentType that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(PIAPIEnvironmentType)environmentType;
/**
 *  Method called when the PIAPIEnvironmentManager did change the environment
 *
 *  @param environmentType The PIAPIEnvironmentType that was changed too
 */
- (void)environmentManagerDidChangeEnvironment:(PIAPIEnvironmentType)environmentType;

@end

@interface PIAPIEnvironmentManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak)   id <PIAPIEnvironmentManagerDelegate> delegate;
@property (nonatomic, assign) PIAPIEnvironmentType defaultEnvironmentType;
@property (nonatomic, strong) NSURL *currentEnvironmentURL;

/**
 *  Set the PIAPIEnvironmentInvokeEvent to present the Environment View
 *
 *  @param invokeEvent PIAPIEnvironmentInvokeEvent that will be triggered
 */
- (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent;

/**
 *  Add a environment to the manager, should be of one type for each DEV, QA, PROD
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environment PIAPIEnvironment to set
 */
- (void)addEnvironment:(PIAPIEnvironment *)environment;

/**
 *  Returns the baseURL for the specified PIAPIEnvironmentType
 *
 *  @param environmentType PIAPIEnvironmentType to return the baseURL
 *
 *  @return baseURL for specified PIAPIEnvironmentType
 */
- (NSURL *)baseURLForEnvironmentType:(PIAPIEnvironmentType)environmentType;

@end
