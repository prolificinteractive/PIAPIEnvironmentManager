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
- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironment *)environment;
- (void)environmentViewDoneButtonPressed:(id)sender;

@end

@interface PIAPIEnvironmentViewController : UITableViewController

@property (nonatomic, readwrite, weak) id <PIAPIEnvironmentViewDelegate> delegate;
@property (nonatomic, readwrite, weak) NSArray *environments;
@property (nonatomic, readwrite, weak) PIAPIEnvironment *currentEnvironment;

@end
