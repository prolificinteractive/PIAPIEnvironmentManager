//
//  EnvironmentModel.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 8/7/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "EnvironmentModel.h"
#import "PIAPIConstants.h"

@implementation EnvironmentModel

+ (NSArray *)defaultEnvironments
{
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

    return @[environmentDEV, environmentQA, environmentPROD];
}

@end
