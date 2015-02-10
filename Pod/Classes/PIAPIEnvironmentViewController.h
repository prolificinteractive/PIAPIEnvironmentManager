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
- (void)environmentViewDidChangeEnvironment:(PIAPIEnvironmentType)environmentType;

@end

@interface PIAPIEnvironmentViewController : UIViewController

@property (nonatomic, weak)   id <PIAPIEnvironmentViewDelegate> delegate;
@property (nonatomic, assign) PIAPIEnvironmentType currentEnvironmentType;

@end
