//
//  EnvironmentModel.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 8/7/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PIAPIEnvironmentManager/PIAPIEnvironmentObject.h>

@interface EnvironmentModel : NSObject <PIAPIEnvironmentObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, strong) NSURL *baseURL;

@property (nonatomic, assign) BOOL isDefaultEnvironment;

@end
