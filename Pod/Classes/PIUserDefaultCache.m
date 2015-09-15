//
//  PIUserDefaultCache.m
//  Pods
//
//  Created by Christopher Jones on 9/11/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

#import <UIKit/UIKit.h>
#import "PIUserDefaultCache.h"

NSString *const kAPIEnvironmentNameUserDefaultsIdentifier = @"PIAPIEnvironmentName";

@interface PIUserDefaultCache ()

@property (nonnull, nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonnull, nonatomic, strong) NSString *key;

@end

@implementation PIUserDefaultCache

- (instancetype)init
{
    return [self initWithKey:kAPIEnvironmentNameUserDefaultsIdentifier];
}

- (instancetype)initWithKey:(NSString *)key
{
    return [self initWithKey:kAPIEnvironmentNameUserDefaultsIdentifier
                userDefaults:[NSUserDefaults standardUserDefaults]];
}

- (instancetype)initWithKey:(NSString *)key
               userDefaults:(NSUserDefaults *)defaults
{
    if (self = [super init]) {
        self.userDefaults = defaults;
        self.key = key;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)retrieveCachedEnvironment
{
    return [self.userDefaults objectForKey:self.key];
}

- (void)cacheEnvironment:(NSString *)environment
{
    [self.userDefaults setObject:environment
                          forKey:self.key];
}

- (void)userDefaultsDidChange
{
    [self.userDefaults synchronize];
}

@end
