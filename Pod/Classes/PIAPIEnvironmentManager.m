//
//  PIAPIEnvironmentManager.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentViewController.h"
#import "PIAPIEnvironment.h"


static NSString *const kAPIEnvironmentManagerIdentifier = @"kAPIEnvironmentManager";

@interface PIAPIEnvironmentManager () <PIAPIEnvironmentViewDelegate> {
    PIAPIEnvironmentType _currentEnvironmentType;
}

@property (nonatomic, strong) NSMutableArray *environments;
@property (nonatomic, strong) PIAPIEnvironmentViewController *environmentViewController;
@property (nonatomic, assign) PIAPIEnvironmentType currentEnvironmentType;

@end

@implementation PIAPIEnvironmentManager

+ (instancetype)sharedManager {
    static PIAPIEnvironmentManager *environmentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        environmentManager = [PIAPIEnvironmentManager new];
    });
    return environmentManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.environments = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Custom Accessors

- (PIAPIEnvironmentViewController *)environmentViewController {
    if (!_environmentViewController) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PIAPIEnvironmentManager" ofType:@"bundle"];

        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];

        _environmentViewController = [[PIAPIEnvironmentViewController alloc] initWithNibName:NSStringFromClass([PIAPIEnvironmentViewController class])
                                                                                      bundle:bundle];
        _environmentViewController.delegate = self;
    }
    _environmentViewController.currentEnvironmentType = self.currentEnvironmentType;
    return _environmentViewController;
}

- (PIAPIEnvironmentType)currentEnvironmentType {
    if (!_currentEnvironmentType) {
        _currentEnvironmentType = [[[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentManagerIdentifier] integerValue];
    }
    return _currentEnvironmentType;
}

- (void)setCurrentEnvironmentType:(PIAPIEnvironmentType)currentEnvironmentType {
    _currentEnvironmentType = currentEnvironmentType;
    [[NSUserDefaults standardUserDefaults] setObject:@(currentEnvironmentType)
                                              forKey:kAPIEnvironmentManagerIdentifier];
}

- (void)setDefaultEnvironmentType:(PIAPIEnvironmentType)environmentType {
    _defaultEnvironmentType = environmentType;

    //The defaultEnvironmentType is not saved if we have a stored environment to remember last environment
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentManagerIdentifier]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(environmentType)
                                                  forKey:kAPIEnvironmentManagerIdentifier];
    }
}

- (NSURL *)currentEnvironmentURL {
    return [self baseURLForEnvironmentType:self.currentEnvironmentType];
}

#pragma mark - Public Methods

- (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                              completion:(void (^)(void))completion {
    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:self.environmentViewController]
                                 animated:animated
                               completion:completion];
}

- (NSURL *)baseURLForEnvironmentType:(PIAPIEnvironmentType)environmentType {
    NSURL *url;
    for (PIAPIEnvironment *environment in self.environments) {
        if (environment.environmentType == environmentType) {
            url = environment.baseURL;
        }
    }
    return url;
}

#pragma mark - Private Methods

- (void)addEnvironment:(PIAPIEnvironment *)environment {
    [self.environments addObject:environment];
}

#pragma mark - PIAPIEnvironmentViewDelegate Methods

- (void)environmentViewWillChangeEnvironment:(PIAPIEnvironmentType)environmentType {
    [self.delegate environmentManagerWillChangeEnvironment:environmentType];
}

- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironmentType)environmentType {
    if (self.currentEnvironmentType != environmentType) {
        self.currentEnvironmentType = environmentType;
    }

    if ([self.delegate respondsToSelector:@selector(environmentManagerDidChangeEnvironment:)]) {
        [self.delegate environmentManagerDidChangeEnvironment:environmentType];
    }
}

@end
