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

@interface PIAPIEnvironmentViewController() <PIAPIEnvironmentTableViewCellDelegate>

@end

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

#pragma mark - Custom Accessors

- (void)setCurrentEnvironment:(PIAPIEnvironment *)currentEnvironment {
    _currentEnvironment = currentEnvironment;

    if ([self.delegate respondsToSelector:@selector(environmentViewDidChangeEnvironment:)]) {
        [self.delegate environmentViewDidChangeEnvironment:_currentEnvironment];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIAPIEnvironmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PIAPIEnvironmentTableViewCell identifier] forIndexPath:indexPath];
    PIAPIEnvironment *environment = self.environments[indexPath.row];
    [cell setEnvironment:environment isCurrentEnvironment:([self.currentEnvironment isEqual:environment])];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

#pragma mark - PIAPIEnvironmentTableViewCellDelegate Methods

- (void)environmentCellSwitchToggled:(UISwitch *)environmentSwitch forEnvironment:(PIAPIEnvironment *)environment
{
    self.currentEnvironment = environment;

    //set all toggles to off
    [self.tableView reloadData];
}

#pragma mark - Action Methods

- (void)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(environmentViewDoneButtonPressed:)]) {
        [self.delegate environmentViewDoneButtonPressed:sender];
    }
}

#pragma mark - Private Methods

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static PIAPIEnvironmentTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[PIAPIEnvironmentTableViewCell identifier]];
    });

    PIAPIEnvironment *environment = self.environments[indexPath.row];
    [sizingCell setEnvironment:environment isCurrentEnvironment:([self.currentEnvironment isEqual:environment])];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    return ([sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]).height;
}

@end
