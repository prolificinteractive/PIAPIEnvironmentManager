//
//  PIExampleEnvironmentManager.m
//  PIAPIEnvironmentManager
//
//  Created by Christopher Jones on 9/11/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

#import "PIExampleEnvironmentManager.h"
#import "EnvironmentModel.h"

@implementation PIExampleEnvironmentManager

+ (PIAPIEnvironmentManager *)defaultEnvironmentManager
{
    static PIAPIEnvironmentManager *manager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[PIAPIEnvironmentManager alloc] initWithEnvironments:[EnvironmentModel defaultEnvironments]];
    });

    return manager;
}

@end
