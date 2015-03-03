//
//  PIAPIEnvironment.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "PIAPIEnvironmentEnums.h"

@interface PIAPIEnvironment : NSObject

@property (nonatomic, readonly) NSString    *name;
@property (nonatomic, readonly) NSURL       *baseURL;
@property (nonatomic, readonly) NSString    *summary;
@property (nonatomic, readonly) NSData      *certificateData;

@property (nonatomic, readonly, assign) BOOL isDefault;

#pragma mark - Class Methods

/**
 *  Class method to create a PIAPIEnvironment
 *
 *  @param name      NSString name of environment (i.e "DEV")
 *  @param baseURL   NSURL of environment, ie: http://environment.com
 *  @param summary   NSString summary/description of environment
 *  @param isDefault BOOL if environment is the default environment selected
 *
 *  @return Instance of PIAPIEnvironment
 */
+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
                            isDefault:(BOOL)isDefault;

/**
 *  Class method to create a PIAPIEnvironment
 *
 *  @param name      NSString name of environment (i.e "DEV")
 *  @param baseURL   NSURL of environment, ie: http://environment.com
 *  @param summary   NSString summary/description of environment
 *  @param isDefault BOOL if environment is the default environment selected
 *  @param certificateName Certificate name. Optional. Can be nil. The certificate must be a .cer format.
 *
 *  @return Instance of PIAPIEnvironment
 */
+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
                          isDefault:(BOOL)isDefault
                        certificateName:(NSString *)certificateName;

#pragma mark - AFNetworking Implementation

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
