//
//  PIAPIEnvironment.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Environment Types currently supported
 */
typedef NS_ENUM (NSInteger, PIAPIEnvironmentType)
{
    /**
     *  Development Environment
     */
    PIAPIEnvironmentTypeDEV = 0,
    /**
     *  QA Environment
     */
    PIAPIEnvironmentTypeQA,
    /**
     *  Production Environment
     */
    PIAPIEnvironmentTypePROD
};

@interface PIAPIEnvironment : NSObject

/**
 *  Class method to create a PIAPIEnvironment instance with a required baseURL and environmentType
 *
 *  @param baseURL         NSURL of environment, ie: http://environment.com
 *  @param environmentType PIAPIEnvironmentType of environment
 *
 *  @return Instance of PIAPIEnvironment with baseURL and environmentType
 */
+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL environmentType:(PIAPIEnvironmentType)environmentType;

@property (nonatomic, readonly) PIAPIEnvironmentType environmentType;
@property (nonatomic, readonly) NSURL *baseURL;

@end
