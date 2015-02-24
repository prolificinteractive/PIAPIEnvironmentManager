//
//  PIAPIEnvironmentViewController.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/21/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironmentViewController.h"
#import "PIAPIEnvironment.h"
#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentEnums.h"

@interface PIAPIEnvironmentViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *environmentPRODSwitch;
@property (weak, nonatomic) IBOutlet UITextField *environmentPRODTextField;
@property (nonatomic, weak) IBOutlet UISwitch *environmentQASwitch;
@property (weak, nonatomic) IBOutlet UITextField *environmentQATextField;
@property (nonatomic, weak) IBOutlet UISwitch *environmentDEVSwitch;
@property (weak, nonatomic) IBOutlet UITextField *environmentDEVTextField;

@end

@implementation PIAPIEnvironmentViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setSwitchStates];
    self.environmentPRODTextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypePROD].absoluteString;
    self.environmentQATextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypeQA].absoluteString;
    self.environmentDEVTextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypeDEV].absoluteString;
}

#pragma mark - Custom Accessors

- (void)setCurrentEnvironmentType:(PIAPIEnvironmentType)currentEnvironmentType {
    if ([self.delegate respondsToSelector:@selector(environmentViewWillChangeEnvironment:)]) {
        [self.delegate environmentViewWillChangeEnvironment:_currentEnvironmentType];
    }

    _currentEnvironmentType = currentEnvironmentType;

    if ([self.delegate respondsToSelector:@selector(environmentViewDidChangeEnvironment:)]) {
        [self.delegate environmentViewDidChangeEnvironment:_currentEnvironmentType];
    }
}

#pragma mark - Action Methods

- (void)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(environmentViewDoneButtonPressed:)]) {
        [self.delegate environmentViewDoneButtonPressed:sender];
    }
}

- (IBAction)environmentSwitchValueChanged:(UISwitch *)environmentSwitch {
    //set the currentEnvironmentType based on the switch toggled.
    self.currentEnvironmentType = [self environmentTypeForSwitch:environmentSwitch];
    [self setSwitchStates];
}

#pragma mark - Private Methods

- (PIAPIEnvironmentType)environmentTypeForSwitch:(UISwitch *)environmentSwitch {
    PIAPIEnvironmentType environmentType;

    if ([environmentSwitch isEqual:self.environmentDEVSwitch]) {
        environmentType = PIAPIEnvironmentTypeDEV;
    }
    else if ([environmentSwitch isEqual:self.environmentQASwitch]) {
        environmentType = PIAPIEnvironmentTypeQA;
    }
    else {
        environmentType = PIAPIEnvironmentTypePROD;
    }


    return environmentType;
}

- (UISwitch *)switchForEnvironmentType:(PIAPIEnvironmentType)environmentType {
    UISwitch *environmentSwitch;
    if (environmentType == PIAPIEnvironmentTypeDEV) {
        environmentSwitch = self.environmentDEVSwitch;
    }
    else if (environmentType == PIAPIEnvironmentTypeQA) {
        environmentSwitch = self.environmentQASwitch;
    }
    else {
        environmentSwitch = self.environmentPRODSwitch;
    }
    return environmentSwitch;
}

- (void)setSwitchStates {
    //set switch states
    self.environmentDEVSwitch.on = ([self.environmentDEVSwitch isEqual:
                                     [self switchForEnvironmentType:self.currentEnvironmentType]]);

    self.environmentQASwitch.on = ([self.environmentQASwitch isEqual:
                                    [self switchForEnvironmentType:self.currentEnvironmentType]]);

    self.environmentPRODSwitch.on = ([self.environmentPRODSwitch isEqual:
                                      [self switchForEnvironmentType:self.currentEnvironmentType]]);
}

@end
