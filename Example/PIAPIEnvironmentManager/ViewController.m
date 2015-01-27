//
//  ViewController.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "ViewController.h"
#import "PIAPIEnvironmentManager.h"

@interface ViewController () <PIAPIEnvironmentManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *currentURLLabel;

@end

@implementation ViewController

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [PIAPIEnvironmentManager sharedManager].delegate = self;
    [[PIAPIEnvironmentManager sharedManager] presentEnvironmentViewControllerInViewController:self
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)environmentManagerWillChangeEnvironment:(PIAPIEnvironmentType)environmentType {
#warning Clear session data
}

- (IBAction)updateURLButtonPressed:(id)sender {
    self.currentURLLabel.text = [[PIAPIEnvironmentManager sharedManager].currentEnvironmentURL absoluteString];
}

@end
