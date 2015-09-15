//
//  PIAPIEnvironmentCacheProvider.h
//  Pods
//
//  Created by Christopher Jones on 9/11/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

/**
 *  Defines an interface for an object to act as a cache provider for PIAPIEnvironmentManager.
 */
@protocol PIAPIEnvironmentCacheProvider <NSObject>

/**
 *  Retrieve the cached environment from the local store.
 *  This should return nil if there has never been any data cached before. 
 *
 *  Implementations of this should not implement any additional logic to return a
 *  default envrionment; this will be handled by the APIEnvironmentManager by default.
 *
 *  @return The cached environment unique identifier.
 */
- (nullable NSString *) retrieveCachedEnvironment;

/**
 *  Cache the input environment's unique identifier.
 *
 *  @param environment The environment to cache. 
 *  This will be a unique identifier for the environment and should be stored exactly as given.
 */
- (void)cacheEnvironment:(nonnull NSString *)environment;

@end
