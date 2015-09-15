//
//  PIAPIEnvironmentViewController.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/21/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentObject.h"

@class PIAPIEnvironmentViewController;

/**
 Defines an interface for receiving events from the APIEnvironmentViewController.
 */
@protocol PIAPIEnvironmentViewDelegate <NSObject>

@required

/**
 Notifies that the environment received a Done event.
 
 @param sender The environment view controller that received the event.
 */
- (void)environmentViewDoneButtonPressed:(nonnull PIAPIEnvironmentViewController *)sender;

@end

/**
 A view controller for controlling the switching of API environments
 */
@interface PIAPIEnvironmentViewController : UITableViewController

/**
 The delegate for the environment view controller.
 */
@property (nullable, nonatomic, readwrite, weak) id <PIAPIEnvironmentViewDelegate> delegate;

/**
 Initializes a new instance of the environment manager view controller using the input environment manager.
 
 @param manager The environment Manager.
 
 @return A new instance.
 */
- (nonnull instancetype)initWithEnvironmentManager:(nonnull PIAPIEnvironmentManager *)manager;

@end
