//
//  PIAPIEnvironment.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIAPIEnvironmentEnums.h"

@interface PIAPIEnvironment : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *summary;

@property (nonatomic, readonly, strong) NSURL  *baseURL;
@property (nonatomic, readonly, strong) NSData *certificateData;

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
 *  @param name             NSString name of environment (i.e "DEV")
 *  @param baseURL          NSURL of environment, ie: http://environment.com
 *  @param summary          NSString summary/description of environment
 *  @param isDefault        BOOL if environment is the default environment selected
 *  @param certificateName  Certificate file name. Optional. Can be nil. The certificate must be a .cer format.
 *
 *  @return Instance of PIAPIEnvironment
 */
+ (instancetype)environmentWithName:(NSString *)name
                            baseURL:(NSURL *)baseURL
                            summary:(NSString *)summary
                          isDefault:(BOOL)isDefault
                        certificateName:(NSString *)certificateName;

@end
