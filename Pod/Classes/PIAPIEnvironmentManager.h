//
//  PIAPIEnvironmentManager.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PIAPIEnvironmentEnums.h"
#import "PIAPIEnvironmentObject.h"

/**
 * User defaults key for API Environment
 * To include environment switching in the Settings bundle, add an item with this key
 * Values should correspond to the enviornment name set in PIAPIEnvironment
 */
extern NSString * _Nonnull const kAPIEnvironmentNameUserDefaultsIdentifier;

@protocol PIAPIEnvironmentManagerDelegate <NSObject>

@optional

/**
 *  Method called when the PIAPIEnvironmentManager will change the environment
 *
 *  @param environment The PIAPIEnvironment that is about to be changed
 */
- (void)environmentManagerWillChangeEnvironment:(_Nonnull id<PIAPIEnvironmentObject>)environmentObject;

/**
 *  Method called when the PIAPIEnvironmentManager did change the environment
 *
 *  @param environment The PIAPIEnvironment that was changed to
 */
- (void)environmentManagerDidChangeEnvironment:(_Nonnull id<PIAPIEnvironmentObject>)environmentObject;

@end

/**
 *  A manager for API Environment changes.
 */
@interface PIAPIEnvironmentManager : NSObject

/**
 *  The environment manager delegate.
 */
@property (nullable, nonatomic, weak) id<PIAPIEnvironmentManagerDelegate> delegate;

/**
 *  The current environment.
 */
@property (nonnull, nonatomic, strong) id<PIAPIEnvironmentObject> currentEnvironment;

/**
 *  All accessible environments.
 */
@property (nonnull, nonatomic, strong, readonly) NSMutableArray <id<PIAPIEnvironmentObject>> *environments;

/**
 *  Initializes a new instance of PIAPIEnvironmentManager with the input environments.
 *
 *  @param environments The environments.
 *
 *  @return A new instance of PIAPIEnvironmentManager.
 */
- (nonnull instancetype)initWithEnvironments:(nonnull NSArray <id<PIAPIEnvironmentObject>> *)environments;

/**
 *  Return the current PIAPIEnvironment that is selected
 *
 *  @return current PIAPIEnvironment
 */
+ (_Nonnull id<PIAPIEnvironmentObject>)currentEnvironment;

/**
 *  Return an array of added environments
 *
 *  @return NSArray of added PIAPIEnvironments
 */
+ ( NSArray * _Nonnull )environments;

/**
 *  Return a PIAPIEnvironment from the its name
 *
 *  @param name NSString the name of the environment
 *
 *  @return PIAPIEnvironment from its name. Will return nil if none match
 */
+ (void) setDelegate: (nonnull id<PIAPIEnvironmentManagerDelegate>)delegate;

/**
 *  Set the PIAPIEnvironmentInvokeEvent to present the Environment View
 *
 *  @param invokeEvent PIAPIEnvironmentInvokeEvent that will be triggered
 */
+ (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)invokeEvent;

/**
 *  Add an array of environments to the manager
 *  Should be called in the your app delegate. (See example project)
 *
 *  @param environments NSArray of PIAPIEnvironments to set
 */
+ (void)addEnvironments:(NSArray * _Nonnull)environments;

/**
 *  Return a PIAPIEnvironment from the its name
 *
 *  @param name NSString the name of the environment
 *
 *  @return PIAPIEnvironment from its name. Will return nil if none match
 */
+ (nullable id<PIAPIEnvironmentObject>)environmentFromName:(NSString * _Nonnull)name;

@end
