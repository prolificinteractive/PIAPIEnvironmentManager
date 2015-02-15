//
//  PAPIEnvironment.m
//  PAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironment.h"

@implementation PIAPIEnvironment

/**
 *  Class method to create a PIAPIEnvironment instance with a required baseURL and environmentType
 *
 *  @param baseURL         NSURL of environment, ie: http://environment.com
 *  @param environmentType PIAPIEnvironmentType of environment
 *
 *  @return Instance of PIAPIEnvironment with baseURL and environmentType
 */
+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL
                       environmentType:(PIAPIEnvironmentType)environmentType {
    return [[self alloc] initWithBaseURL:baseURL
                         environmentType:environmentType];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                environmentType:(PIAPIEnvironmentType)environmentType {
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _environmentType = environmentType;
    }
    return self;
}

@end
