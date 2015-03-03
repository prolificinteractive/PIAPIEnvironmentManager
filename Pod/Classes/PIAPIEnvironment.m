//
//  PAPIEnvironment.m
//  PAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironment.h"

@implementation PIAPIEnvironment

#pragma mark - Init Methods

- (instancetype)initWithName:(NSString *)name
                     baseURL:(NSURL *)baseURL
                     summary:(NSString *)summary
                     isDefault:(BOOL)isDefault
             certificateName:(NSString *)certificateName
{
    self = [super init];
    if (self) {
        _name       = name;
        _baseURL    = baseURL;
        _summary    = summary;
        _isDefault  = isDefault;

        if (certificateName) {
            _certificateData = [NSData dataWithContentsOfFile:certificateName];
        }
    }
    return self;
}

#pragma mark - Class Methods

+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
                            isDefault:(BOOL)isDefault
{
    return [[self alloc] initWithName:name
                              baseURL:baseURL
                              summary:summary
                            isDefault:isDefault
                      certificateName:nil];
}

+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
                          isDefault:(BOOL)isDefault
                    certificateName:(NSString *)certificateName
{
    // certificateName can be nil.
    if (certificateName) {
        NSString *fileType = [[[certificateName lastPathComponent] componentsSeparatedByString:@"."] lastObject];
        NSAssert([fileType isEqualToString:@"cer"], @"Certificate file must be a .cer format");
    }

    return [[self alloc] initWithName:name
                              baseURL:baseURL
                              summary:summary
                            isDefault:isDefault
                      certificateName:certificateName];
}

#pragma mark - AFNetworking Implementation

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
