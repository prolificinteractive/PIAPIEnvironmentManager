//
//  AppDelegate.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "PIAPIEnvironmentManager.h"
#import "PIAPIConstants.h"
#import "PIAPIEnvironment.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAPIEnvironments];
    return YES;
}

- (void)setupAPIEnvironments {
    //create environments
    PIAPIEnvironment *environmentDEV = [PIAPIEnvironment environmentWithBaseURL:[NSURL URLWithString:kEnvironmentDEVBaseURL]
                                                                environmentType:PIAPIEnvironmentTypeDEV];
    PIAPIEnvironment *environmentQA = [PIAPIEnvironment environmentWithBaseURL:[NSURL URLWithString:kEnvironmentQABaseURL]
                                                               environmentType:PIAPIEnvironmentTypeQA];
    PIAPIEnvironment *environmentPROD = [PIAPIEnvironment environmentWithBaseURL:[NSURL URLWithString:kEnvironmentPRODBaseURL]
                                                                 environmentType:PIAPIEnvironmentTypePROD];

    //add environments to manager
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentDEV];
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentQA];
    [[PIAPIEnvironmentManager sharedManager] addEnvironment:environmentPROD];

    //set default environment
    [PIAPIEnvironmentManager sharedManager].defaultEnvironmentType = PIAPIEnvironmentTypeDEV;
}

@end
