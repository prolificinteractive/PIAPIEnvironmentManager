//
//  PIAPIEnvironmentObject.h
//  Pods
//
//  Created by Julio Rivera on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

/**
 *  Protocol that your environment model class must conform to
 */
@protocol PIAPIEnvironmentObject <NSObject>

@required

/**
 *  NSURL of your environment
 */
@property (nonnull, nonatomic, strong) NSURL *baseURL;

/**
 *  Name of your environment. This will display in the UI.
 */
@property (nonnull, nonatomic, copy) NSString *name;

/**
 *  Summary of your environment. This will display in the UI.
 */
@property (nullable, nonatomic, copy) NSString *summary;


@end