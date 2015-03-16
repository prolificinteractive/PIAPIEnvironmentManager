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
                                                                     summary:@"This is the dev environment"
                                                                   isDefault:NO];
    PIAPIEnvironment *environmentQA = [PIAPIEnvironment environmentWithName:@"QA"
                                                                    baseURL:[NSURL URLWithString:kEnvironmentQABaseURL]
                                                                    summary:@"This is the QA environment"
                                                                  isDefault:NO];
    PIAPIEnvironment *environmentPROD = [PIAPIEnvironment environmentWithName:@"PROD"
                                                                      baseURL:[NSURL URLWithString:kEnvironmentPRODBaseURL]
                                                                      summary:@"This is the production environment"
                                                                    isDefault:YES];
    //add environments to manager
    [PIAPIEnvironmentManager addEnvironments:@[environmentDEV, environmentQA, environmentPROD]];

    [PIAPIEnvironmentManager setInvokeEvent:PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft];
}

@end
