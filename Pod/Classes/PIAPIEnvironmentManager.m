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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
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
        _currentEnvironmentType = [self environmentTypeFromUserDefaults];
    }
    return _currentEnvironmentType;
}

- (void)setCurrentEnvironmentType:(PIAPIEnvironmentType)environmentType {
    
    if (_currentEnvironmentType == environmentType) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(environmentManagerWillChangeEnvironment:)]) {
        [self.delegate environmentManagerWillChangeEnvironment:environmentType];
    }
    
    _currentEnvironmentType = environmentType;
    [self setUserDefaultsEnvironmentType:environmentType];
    
    if ([self.delegate respondsToSelector:@selector(environmentManagerDidChangeEnvironment:)]) {
        [self.delegate environmentManagerDidChangeEnvironment:environmentType];
    }
}

- (void)setDefaultEnvironmentType:(PIAPIEnvironmentType)environmentType {
    _defaultEnvironmentType = environmentType;

    //The defaultEnvironmentType is not saved if we have a stored environment to remember last environment
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentTypeUserDefaultsIdentifier]) {
        [self setUserDefaultsEnvironmentType:environmentType];
    }
}

- (PIAPIEnvironment *)currentEnvironment
{
    return [self environmentForEnvironmentType:self.currentEnvironmentType];
}

- (NSURL *)currentEnvironmentURL {
    return self.currentEnvironment.baseURL;
}

#pragma mark - User Defaults
- (PIAPIEnvironmentType)environmentTypeFromUserDefaults
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kAPIEnvironmentTypeUserDefaultsIdentifier] integerValue];
}

- (void)setUserDefaultsEnvironmentType:(PIAPIEnvironmentType)environmentType
{
    if ([self environmentTypeFromUserDefaults] != environmentType) {
        [[NSUserDefaults standardUserDefaults] setObject:@(environmentType)
                                                  forKey:kAPIEnvironmentTypeUserDefaultsIdentifier];
    }
}
#pragma mark - Public Methods

- (void)presentEnvironmentViewControllerInViewController:(UIViewController *)viewController
                                                animated:(BOOL)animated
                                              completion:(void (^)(void))completion {
    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:self.environmentViewController]
                                 animated:animated
                               completion:completion];
}

- (PIAPIEnvironment *)environmentForEnvironmentType:(PIAPIEnvironmentType)environmentType
{
    for (PIAPIEnvironment *environment in self.environments) {
        if (environment.environmentType == environmentType) {
            return environment;
        }
    }
    return nil;
}

#pragma mark - Notifications

- (void)userDefaultsDidChange
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentEnvironmentType = [self environmentTypeFromUserDefaults];
}

#pragma mark - Private Methods

- (void)addEnvironment:(PIAPIEnvironment *)environment {
    [self.environments addObject:environment];
}

#pragma mark - PIAPIEnvironmentViewDelegate Methods

- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironmentType)environmentType {
    self.currentEnvironmentType = environmentType;
}

@end
