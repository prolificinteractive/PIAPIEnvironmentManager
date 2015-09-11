//
//  AppDelegate.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "PIAPIConstants.h"
#import "EnvironmentModel.h"
#import <PIAPIEnvironmentManager/PIAPIEnvironmentManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAPIEnvironments];
    return YES;
}

- (void)setupAPIEnvironments {
    //create environments
    EnvironmentModel *environmentDEV = [EnvironmentModel new];
    environmentDEV.name = @"DEV";
    environmentDEV.baseURL = [NSURL URLWithString:kEnvironmentDEVBaseURL];
    environmentDEV.summary = @"This is the DEV environment";
    environmentDEV.isDefaultEnvironment = NO;
    
    EnvironmentModel *environmentQA = [EnvironmentModel new];
    environmentQA.name = @"QA";
    environmentQA.baseURL = [NSURL URLWithString:kEnvironmentQABaseURL];
    environmentQA.summary = @"This is the QA environment";
    environmentQA.isDefaultEnvironment = NO;

    EnvironmentModel *environmentPROD = [EnvironmentModel new];
    environmentPROD.name = @"PROD";
    environmentPROD.baseURL = [NSURL URLWithString:kEnvironmentPRODBaseURL];
    environmentPROD.summary = @"This is the PROD environment";
    environmentPROD.isDefaultEnvironment = YES;

    //add environments to manager
    [PIAPIEnvironmentManager addEnvironments:@[environmentDEV, environmentQA, environmentPROD]];

    [PIAPIEnvironmentManager setInvokeEvent:PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft];
}

@end
