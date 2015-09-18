//
//  PIAPIEnvironmentTableViewCell.m
//  Pods
//
//  Created by Julio Rivera on 3/2/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

#import "PIAPIEnvironmentTableViewCell.h"
#import "PIAPIEnvironmentManager.h"

@interface PIAPIEnvironmentTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *environmentNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *environmentURLTextFIeld;
@property (nonatomic, weak) IBOutlet UILabel *environmentSummaryLabel;
@property (nonatomic, weak) IBOutlet UISwitch *environmentSwitch;

@property (nonatomic, weak) id<PIAPIEnvironmentObject> environment;

@end

@implementation PIAPIEnvironmentTableViewCell

- (void)setEnvironment:(id<PIAPIEnvironmentObject>)environment isCurrentEnvironment:(BOOL)isCurrentEnvironment
{
    self.environment                    = environment;
    self.environmentNameLabel.text      = environment.name;
    self.environmentURLTextFIeld.text   = environment.baseURL.absoluteString;
    self.environmentSummaryLabel.text   = environment.summary;
    self.environmentSwitch.on           = isCurrentEnvironment;
}

- (IBAction)environmentSwitchValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(environmentCellSwitchToggled:forEnvironment:)]){
        [self.delegate environmentCellSwitchToggled:sender forEnvironment:self.environment];
    }
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

@end
