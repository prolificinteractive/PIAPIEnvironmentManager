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
#import "PIInvokeManager.h"
#import "PIExampleEnvironmentManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAPIEnvironments];
    return YES;
}

- (void)setupAPIEnvironments
{
    PIAPIEnvironmentManager *environmentManager = [PIExampleEnvironmentManager defaultEnvironmentManager];

    [PIInvokeManager setInvokeEvent:PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft
                         forManager:environmentManager];
}

@end
