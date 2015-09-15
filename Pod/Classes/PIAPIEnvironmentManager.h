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
#import "PIAPIEnvironmentCacheProvider.h"

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@optional

/**
 *  Method called when the PIAPIEnvironmentManager will change the environment
 *
 *  @param environment The PIAPIEnvironment that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(_Nonnull id<PIAPIEnvironmentObject>)environmentObject;

/**
 *  Method called when the PIAPIEnvironmentManager did change the environment
 *
 *  @param environment The PIAPIEnvironment that was changed to
 */
- (void)environmentManagerDidChangeEnvironment:(_Nonnull id<PIAPIEnvironmentObject>)environmentObject;

@end

/**
 *  A manager for API Environment changes.
 */
@interface PIAPIEnvironmentManager : NSObject

/**
 *  The environment manager delegate.
 */
@property (nullable, nonatomic, weak) id<PIAPIEnvironmentManagerDelegate> delegate;

/**
 *  The current environment.
 */
@property (nonnull, nonatomic, strong) id<PIAPIEnvironmentObject> currentEnvironment;

/**
 *  Initializes a new instance of PIAPIEnvironmentManager with the input environments and default cache.
 *
 *  @param environments The environments.
 *
 *  @return A new instance of PIAPIEnvironmentManager.
 */
- (nonnull instancetype)initWithEnvironments:(nonnull NSArray <id<PIAPIEnvironmentObject>> *)environments;

/**
 *  Initializes a new instance of PIAPIEnvironmentManager with the input environments and cache.
 *
 *  @param environments     The environments.
 *  @params cacheProvider   The cache provider.
 *
 *  @return A new instance of PIAPIEnvironmentManager.
 */
- (nonnull instancetype)initWithEnvironments:(nonnull NSArray<id<PIAPIEnvironmentObject>> *)environments
                               cacheProvider:(nonnull id<PIAPIEnvironmentCacheProvider>)cacheProvider;

/**
 *  Adds the input environment to the environment list.
 *  
 *  @param environment  The environment to add.
 */
- (void)addEnvironment:(nonnull id<PIAPIEnvironmentObject>)environment;

/**
 *  All accessible environments.
 *
 *  @return All environments.
 */
- (nonnull NSArray<id<PIAPIEnvironmentObject>> *)allEnvironments;

/**
 *  Add an array of environments to the manager
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environments NSArray of PIAPIEnvironments to set
 */
- (void)addEnvironments:(NSArray <id<PIAPIEnvironmentObject>> * _Nonnull)environments;


@end
