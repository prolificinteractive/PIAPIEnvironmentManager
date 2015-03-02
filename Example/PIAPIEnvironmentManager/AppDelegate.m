//
//  AppDelegate.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "PIAPIConstants.h"
#import <PIAPIEnvironmentManager/PIAPIEnvironmentManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAPIEnvironments];
    return YES;
}

- (void)setupAPIEnvironments {
    //create environments
    PIAPIEnvironment *environmentDEV = [PIAPIEnvironment environmentWithName:@"DEV"
                                                                     baseURL:[NSURL URLWithString:kEnvironmentDEVBaseURL]
                                                                     summary:@"dev environment"];
    PIAPIEnvironment *environmentQA = [PIAPIEnvironment environmentWithName:@"STAGING"
                                                                     baseURL:[NSURL URLWithString:kEnvironmentQABaseURL]
                                                                     summary:@"staging environment"];
    PIAPIEnvironment *environmentPROD = [PIAPIEnvironment environmentWithName:@"PROD"
                                                                     baseURL:[NSURL URLWithString:kEnvironmentPRODBaseURL]
                                                                     summary:@"prod environment"];
    //add environments to manager
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentDEV];
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentQA];
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentPROD];

    //set default environment
    [PIAPIEnvironmentManager sharedManager].defaultEnvironmentType = PIAPIEnvironmentTypeDEV;

    [[PIAPIEnvironmentManager sharedManager] setInvokeEvent:PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft];
}

@end
