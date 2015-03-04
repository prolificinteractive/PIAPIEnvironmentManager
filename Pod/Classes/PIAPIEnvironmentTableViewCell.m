//
//  PIAPIEnvironmentTableViewCell.m
//  Pods
//
//  Created by Julio Rivera on 3/2/15.
//
//

#import "PIAPIEnvironmentTableViewCell.h"
#import "PIAPIEnvironment.h"

@interface PIAPIEnvironmentTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *environmentNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *environmentURLTextFIeld;
@property (nonatomic, weak) IBOutlet UILabel *environmentSummaryLabel;
@property (nonatomic, weak) IBOutlet UISwitch *environmentSwitch;

@property (nonatomic, weak) PIAPIEnvironment *environment;

@end

@implementation PIAPIEnvironmentTableViewCell

- (void)setEnvironment:(PIAPIEnvironment *)environment isCurrentEnvironment:(BOOL)isCurrentEnvironment
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
