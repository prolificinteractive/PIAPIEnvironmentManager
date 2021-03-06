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

@interface PIAPIEnvironmentViewController() <PIAPIEnvironmentTableViewCellDelegate>

@property (nonnull, nonatomic, strong) PIAPIEnvironmentManager *environmentManager;

@end

@implementation PIAPIEnvironmentViewController

- (instancetype)initWithEnvironmentManager:(PIAPIEnvironmentManager *)manager
{
    if (self = [super init]) {
        self.environmentManager = manager;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Environments";

    NSString *resourcePath = [[NSBundle bundleForClass:[PIAPIEnvironmentTableViewCell class]] pathForResource:@"PIAPIEnvironmentManager" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourcePath];

    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([PIAPIEnvironmentTableViewCell class]) bundle:resourceBundle];

    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[PIAPIEnvironmentTableViewCell identifier]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonPressed:)];
}

#pragma mark - Custom Accessors

- (void)setCurrentEnvironment:(nonnull id<PIAPIEnvironmentObject>)currentEnvironment
{
    self.environmentManager.currentEnvironment = currentEnvironment;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentManager.allEnvironments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIAPIEnvironmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PIAPIEnvironmentTableViewCell identifier] forIndexPath:indexPath];
   
    id<PIAPIEnvironmentObject> environment = self.environmentManager.allEnvironments[indexPath.row];

    NSString *currentEnvironmentName = [self.environmentManager.currentEnvironment name];
    BOOL isCurrentEnvironment = [currentEnvironmentName isEqualToString:[environment name]];

    [cell setEnvironment:environment isCurrentEnvironment:isCurrentEnvironment];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

#pragma mark - PIAPIEnvironmentTableViewCellDelegate Methods

- (void)environmentCellSwitchToggled:(UISwitch *)environmentSwitch forEnvironment:(id<PIAPIEnvironmentObject>)environment
{
    self.currentEnvironment = environment;

    //set all toggles to off
    [self.tableView reloadData];
}

#pragma mark - Action Methods

- (void)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(environmentViewDoneButtonPressed:)]) {
        [self.delegate environmentViewDoneButtonPressed:self];
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

    id<PIAPIEnvironmentObject> environment = self.environmentManager.allEnvironments[indexPath.row];
    [sizingCell setEnvironment:environment isCurrentEnvironment:([self.environmentManager.currentEnvironment isEqual:environment])];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    return ([sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]).height;
}

@end
