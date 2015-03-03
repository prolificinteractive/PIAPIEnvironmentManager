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
- (void)environmentViewWillChangeEnvironment:(PIAPIEnvironment *)environment;
- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironment *)environment;
- (void)environmentViewDoneButtonPressed:(id)sender;

@end

@interface PIAPIEnvironmentViewController : UITableViewController

@property (nonatomic, weak) id <PIAPIEnvironmentViewDelegate> delegate;
@property (nonatomic, weak) NSArray *environments;
@property (nonatomic, weak) PIAPIEnvironment *currentEnvironment;

@end
