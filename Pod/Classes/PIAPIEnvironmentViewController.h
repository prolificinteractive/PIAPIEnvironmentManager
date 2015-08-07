//
//  PIAPIEnvironmentViewController.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/21/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIAPIEnvironmentManager.h"

@protocol PIAPIEnvironmentViewDelegate <NSObject>

@required
- (void)environmentViewDidChangeEnvironment:(id<PIAPIEnvironmentObject>)environment;
- (void)environmentViewDoneButtonPressed:(id)sender;

@end

@interface PIAPIEnvironmentViewController : UITableViewController

@property (nonatomic, readwrite, weak) id <PIAPIEnvironmentViewDelegate> delegate;
@property (nonatomic, readwrite, weak) NSArray *environments;
@property (nonatomic, readwrite, weak) id<PIAPIEnvironmentObject>currentEnvironment;

@end
