//
//  PIUserDefaultCache.h
//  Pods
//
//  Created by Christopher Jones on 9/11/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

#import "PIAPIEnvironmentCacheProvider.h"

/**
 *  A PIAPIEnvironmentManager cache utilizing NSUserDefaults for storage.
 */
@interface PIUserDefaultCache : NSObject <PIAPIEnvironmentCacheProvider>

/**
 *  Initializes a new instance using the standardUserDefaults store.
 *
 *  @return A new instance.
 */
- (nonnull instancetype)init;

/**
 *  Initializes a new instance using the default userDefaults and the specified key.
 *
 *  @param key The key to use to store the APIEnvironment to NSUserDefaults
 *
 *  @return A new instance.
 */
- (nonnull instancetype)initWithKey:(nonnull NSString *)key;

/**
 *  Initializes a new instance using the input user defaults store.
 *
 *  @param defaults The user defaults to use for storage.
 *  
 *  @return A new instance.
 */
- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                       userDefaults:(nonnull NSUserDefaults *)defaults;

@end
