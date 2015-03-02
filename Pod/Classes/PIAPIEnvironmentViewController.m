//
//  PIAPIEnvironmentViewController.m
//  PIAPIEnvironmentManager
//
//  Created by Julio Rivera on 1/21/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

#import "PIAPIEnvironmentViewController.h"
#import "PIAPIEnvironmentTableViewCell.h"
#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentEnums.h"
#import "PIAPIEnvironment.h"

@implementation PIAPIEnvironmentViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Environments";

    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PIAPIEnvironmentManager" ofType:@"bundle"]];

    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([PIAPIEnvironmentTableViewCell class]) bundle:bundle];

    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[PIAPIEnvironmentTableViewCell identifier]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonPressed:)];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self setSwitchStates];
//    self.environmentPRODTextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypePROD].absoluteString;
//    self.environmentQATextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypeQA].absoluteString;
//    self.environmentDEVTextField.text = [[PIAPIEnvironmentManager sharedManager] baseURLForEnvironmentType:PIAPIEnvironmentTypeDEV].absoluteString;
//}

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

//- (IBAction)environmentSwitchValueChanged:(UISwitch *)environmentSwitch {
//    //set the currentEnvironmentType based on the switch toggled.
//    self.currentEnvironmentType = [self environmentTypeForSwitch:environmentSwitch];
//    [self setSwitchStates];
//}

#pragma mark - Private Methods

//- (PIAPIEnvironmentType)environmentTypeForSwitch:(UISwitch *)environmentSwitch {
//    PIAPIEnvironmentType environmentType;
//
//    if ([environmentSwitch isEqual:self.environmentDEVSwitch]) {
//        environmentType = PIAPIEnvironmentTypeDEV;
//    }
//    else if ([environmentSwitch isEqual:self.environmentQASwitch]) {
//        environmentType = PIAPIEnvironmentTypeQA;
//    }
//    else {
//        environmentType = PIAPIEnvironmentTypePROD;
//    }
//
//
//    return environmentType;
//}
//
//- (UISwitch *)switchForEnvironmentType:(PIAPIEnvironmentType)environmentType {
//    UISwitch *environmentSwitch;
//    if (environmentType == PIAPIEnvironmentTypeDEV) {
//        environmentSwitch = self.environmentDEVSwitch;
//    }
//    else if (environmentType == PIAPIEnvironmentTypeQA) {
//        environmentSwitch = self.environmentQASwitch;
//    }
//    else {
//        environmentSwitch = self.environmentPRODSwitch;
//    }
//    return environmentSwitch;
//}
//
//- (void)setSwitchStates {
//    //set switch states
//    self.environmentDEVSwitch.on = ([self.environmentDEVSwitch isEqual:
//                                     [self switchForEnvironmentType:self.currentEnvironmentType]]);
//
//    self.environmentQASwitch.on = ([self.environmentQASwitch isEqual:
//                                    [self switchForEnvironmentType:self.currentEnvironmentType]]);
//
//    self.environmentPRODSwitch.on = ([self.environmentPRODSwitch isEqual:
//                                      [self switchForEnvironmentType:self.currentEnvironmentType]]);
//}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIAPIEnvironmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PIAPIEnvironmentTableViewCell identifier] forIndexPath:indexPath];
    cell.environment = self.environments[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)calculateHeightForSizingCell:(PIAPIEnvironmentTableViewCell *)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static PIAPIEnvironmentTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[PIAPIEnvironmentTableViewCell identifier]];
    });

    sizingCell.environment = self.environments[indexPath.row];
    return [self calculateHeightForSizingCell:sizingCell];
}
@end
