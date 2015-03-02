//
//  PIAPIEnvironmentViewController.h
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/21/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIAPIEnvironment.h"

@protocol PIAPIEnvironmentViewDelegate <NSObject>

@required
- (void)environmentViewWillChangeEnvironment:(PIAPIEnvironmentType)environmentType;
- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironmentType)environmentType;
- (void)environmentViewDoneButtonPressed:(id)sender;

@end

@interface PIAPIEnvironmentViewController : UITableViewController

@property (nonatomic, weak) id <PIAPIEnvironmentViewDelegate> delegate;
@property (nonatomic, weak) NSArray *environments;

@property (nonatomic, assign) PIAPIEnvironmentType currentEnvironmentType;

@end
