//
//  ViewController.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "EnvironmentModel.h"
#import "ViewController.h"

#import "PIExampleEnvironmentManager.h"

@interface ViewController () <PIAPIEnvironmentManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *currentURLLabel;

@end

@implementation ViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [PIExampleEnvironmentManager defaultEnvironmentManager].delegate = self;
}

#pragma mark - Action Methods

- (IBAction)updateURLButtonPressed:(id)sender
{
    self.currentURLLabel.text = [[PIExampleEnvironmentManager defaultEnvironmentManager].currentEnvironment name];
}

#pragma mark - <PIAPIEnvironmentManagerDelegate>

- (void)environmentManagerDidChangeEnvironment:(id<PIAPIEnvironmentObject>)environmentObject
{
    if ([environmentObject isKindOfClass:[EnvironmentModel class]]){
        EnvironmentModel *environment = (EnvironmentModel *)environmentObject;
        self.currentURLLabel.text = environment.baseURL.absoluteString;
    }
}

@end
