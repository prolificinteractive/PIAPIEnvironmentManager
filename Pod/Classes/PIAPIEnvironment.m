//
//  PAPIEnvironment.m
//  PAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironment.h"

@implementation PIAPIEnvironment

+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
{
    return [[self alloc] initWithName:name
                              baseURL:baseURL
                              summary:summary];
}


/**
 *  Class method to create a PIAPIEnvironment instance with a required baseURL and environmentType
 *
 *  @param baseURL         NSURL of environment, ie: http://environment.com
 *  @param environmentType PIAPIEnvironmentType of environment
 *
 *  @return Instance of PIAPIEnvironment with baseURL and environmentType
 */
+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL
                       environmentType:(PIAPIEnvironmentType)environmentType
{
    return [self environmentWithBaseURL:baseURL
                        environmentType:environmentType
                        certificateName:nil];
}

+ (instancetype)environmentWithBaseURL:(NSURL *)baseURL
                       environmentType:(PIAPIEnvironmentType)environmentType
                       certificateName:(NSString *)certificateName
{
    // certificateName can be nil.
    if (certificateName) {
        NSString *fileType = [[[certificateName lastPathComponent] componentsSeparatedByString:@"."] lastObject];
        NSAssert([fileType isEqualToString:@"cer"], @"Certificate file must be a .cer format");
    }

    return [[self alloc] initWithBaseURL:baseURL
                         environmentType:environmentType
                         certificateName:certificateName];
}

- (instancetype)initWithName:(NSString *)name
                     baseURL:(NSURL *)baseURL
                     summary:(NSString *)summary
{
    self = [super init];
    if (self) {
        _name       = name;
        _baseURL    = baseURL;
        _summary    = summary;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                environmentType:(PIAPIEnvironmentType)environmentType
                certificateName:(NSString *)certificateName
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _environmentType = environmentType;
        if (certificateName) {
            _certificateData = [NSData dataWithContentsOfFile:certificateName];
        }
    }
    return self;
}

- (id <AFURLRequestSerialization> )requestSerializer
{
    return [AFJSONRequestSerializer serializer];
}

- (id <AFURLResponseSerialization> )responseSerializer
{
    return [AFJSONResponseSerializer serializer];
}

- (void)authenticateRequest:(NSURLRequest *)request
{
    // Override in subclass
}

- (NSError *)errorForResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject
{
    // Override in subclass
    return nil;
}

- (void)responseDidSucceed:(NSHTTPURLResponse *)response responseObject:(id)responseObject
{
    // Override in subclass
}

@end
