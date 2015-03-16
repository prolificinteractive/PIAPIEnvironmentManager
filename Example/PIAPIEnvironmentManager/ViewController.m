//
//  ViewController.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/20/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "ViewController.h"
#import <PIAPIEnvironmentManager/PIAPIEnvironmentManager.h>

@interface ViewController () <PIAPIEnvironmentManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *currentURLLabel;

@end

@implementation ViewController

- (IBAction)updateURLButtonPressed:(id)sender {
    self.currentURLLabel.text = [[PIAPIEnvironmentManager currentEnvironmentURL] absoluteString];
}

@end
