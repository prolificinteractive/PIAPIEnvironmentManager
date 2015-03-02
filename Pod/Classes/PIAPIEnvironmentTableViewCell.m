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

@end
@implementation PIAPIEnvironmentTableViewCell

- (void)setEnvironment:(PIAPIEnvironment *)environment
{
    _environment = environment;
    self.environmentNameLabel.text = environment.name;
    self.environmentURLTextFIeld.text = environment.baseURL.absoluteString;
    self.environmentSummaryLabel.text = environment.summary;
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}
@end
