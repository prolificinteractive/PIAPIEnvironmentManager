//
//  PIAPIEnvironment.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEnums.h"

@interface PIAPIEnvironment : NSObject

@property (nonatomic, readonly) PIAPIEnvironmentType environmentType;
@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) NSData *certificateData;

/**
 *  Class method to create a PIAPIEnvironment instance with a required baseURL and environmentType
 *
 *  @param baseURL         NSURL of environment, ie: http://environment.com
 *  @param environmentType PIAPIEnvironmentType of environment
 *
 *  @return Instance of PIAPIEnvironment with baseURL and environmentType
 */
+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL
                       environmentType:(PIAPIEnvironmentType)environmentType;

/**
 *  Class method to create a PIAPIEnvironment instance with a required baseURL and environmentType
 *
 *  @param baseURL         NSURL of environment, ie: http://environment.com
 *  @param environmentType PIAPIEnvironmentType of environment
 *  @param certificateName Certificate name. Optional. Can be nil. The certificate must be a .cer format.
 *
 *  @return Instance of PIAPIEnvironment with baseURL and environmentType
 */
+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL
                       environmentType:(PIAPIEnvironmentType)environmentType
                       certificateName:(NSString *)certificateName;

/**
 * Override the request and response serialization behavior
 * Defaults to AFJSONRequestSerializer/AFJSONResponseSerializer
 */
- (id <AFURLRequestSerialization> ) requestSerializer;
- (id <AFURLResponseSerialization> )responseSerializer;

/**
 * Handle any kind of API-specific request authorization
 *  OAuth, basic auth, sessionID, etc
 *
 * @param request NSURLRequest to be authenticated
 */
- (void)authenticateRequest:(NSMutableURLRequest *)request;

/**
 * Check the response for an error and return it if there is one
 *
 * @param response  NSHTTPURLResponse from API
 * @param id        responseObject JSON object returned from API
 *
 * @return NSError or nil
 */
- (NSError *)errorForResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject;

/**
 * Handle any cleanup from the request (e.g. saving tokens, etc)
 *
 * @param response  NSHTTPURLResponse from API
 * @param id        responseObject JSON object returned from API
 */
- (void)responseDidSucceed:(NSHTTPURLResponse *)response responseObject:(id)responseObject;

@end
