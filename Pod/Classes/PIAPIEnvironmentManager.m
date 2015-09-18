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
#import "PIUserDefaultCache.h"

@interface PIAPIEnvironmentManager ()

@property (nonnull, nonatomic, strong) id<PIAPIEnvironmentCacheProvider> cache;

@property (nonnull, nonatomic, strong, readonly) NSMutableArray <id<PIAPIEnvironmentObject>> *environments;

@end

@implementation PIAPIEnvironmentManager

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"APIEnvironmentManager must be initialized using %@", NSStringFromSelector(@selector(initWithEnvironments:))]
                                 userInfo:nil];
}

- (instancetype)initWithEnvironments:(NSArray<id<PIAPIEnvironmentObject>> *)environments
{
    NSAssert(environments.count > 0, @"Cannot initialize PIAPIEnvironmentManager with 0 environments.");
    PIUserDefaultCache *defaultCache = [[PIUserDefaultCache alloc] init];
    return [self initWithEnvironments:environments cacheProvider:defaultCache];
}

- (instancetype)initWithEnvironments:(NSArray<id<PIAPIEnvironmentObject>> *)environments
                       cacheProvider:(id<PIAPIEnvironmentCacheProvider>)cacheProvider
{
    if (self = [super init]) {
        _environments = [NSMutableArray arrayWithArray:environments];

        self.cache = cacheProvider;
        [self setDefaultEnvironmentFromCacheIfNeeded];
    }

    return self;
}

// Retrieves the currently cached environment and sets the current environment from it.
// If no cached environment is found, it is set to the first environment in the list.
- (void)setDefaultEnvironmentFromCacheIfNeeded
{
    if (!self.currentEnvironment) {
        id <PIAPIEnvironmentObject> currentEnvironment = [self environmentFromCache];

        if (!currentEnvironment && self.environments.count > 0) {
            self.currentEnvironment = self.environments[0];
            [self cacheCurrentEnvironment:self.currentEnvironment];
        } else if (currentEnvironment) {
            self.currentEnvironment = currentEnvironment;
        }
    }
}

- (void)setCurrentEnvironment:(id<PIAPIEnvironmentObject>)currentEnvironment
{
    if (_currentEnvironment != currentEnvironment) {
        if ([self.delegate respondsToSelector:@selector(environmentManagerWillChangeEnvironment:)]) {
            [self.delegate environmentManagerWillChangeEnvironment:currentEnvironment];
        }

        _currentEnvironment = currentEnvironment;

        if ([self.delegate respondsToSelector:@selector(environmentManagerDidChangeEnvironment:)]) {
            [self.delegate environmentManagerDidChangeEnvironment:currentEnvironment];
        }
    }

    [self cacheCurrentEnvironment:currentEnvironment];
}

- (NSArray *)allEnvironments
{
    return [self.environments copy];
}

- (void)addEnvironment:(id<PIAPIEnvironmentObject>)environmentObject
{
    [self.environments addObject:environmentObject];
    [self setDefaultEnvironmentFromCacheIfNeeded];
}

- (void)addEnvironments:(NSArray <id<PIAPIEnvironmentObject>>*)environments
{
    for (id<PIAPIEnvironmentObject> environment in environments) {
        [self addEnvironment:environment];
    }
}

- (nonnull id<PIAPIEnvironmentObject>)environmentFromName:(NSString *)name
{
    for (id<PIAPIEnvironmentObject> environment in self.environments) {
        if ([name isEqualToString:environment.name]) {
            return environment;
        }
    }

    return nil;
}

#pragma mark - Cache

- (nullable NSString *)environmentNameFromCache
{
    return [self.cache retrieveCachedEnvironment];
}
        
- (nullable id<PIAPIEnvironmentObject>)environmentFromCache
{
    NSString *cachedEnvironment = [self environmentNameFromCache];

    if (cachedEnvironment) {
        return [self environmentFromName:cachedEnvironment];
    }

    return nil;
}

- (void)cacheCurrentEnvironment:(id<PIAPIEnvironmentObject>)environment
{
    [self.cache cacheEnvironment:[environment name]];
}


@end
