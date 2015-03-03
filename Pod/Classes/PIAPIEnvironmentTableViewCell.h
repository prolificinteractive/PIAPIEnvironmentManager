//
//  PIAPIEnvironmentTableViewCell.h
//  Pods
//
//  Created by Julio Rivera on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@class PIAPIEnvironment;

@protocol PIAPIEnvironmentTableViewCellDelegate <NSObject>

- (void) environmentCellSwitchToggled:(UISwitch *)environmentSwitch
                       forEnvironment:(PIAPIEnvironment *)environment;

@end

@interface PIAPIEnvironmentTableViewCell : UITableViewCell

@property (nonatomic, readwrite, weak) id<PIAPIEnvironmentTableViewCellDelegate> delegate;

@property (nonatomic, readonly, weak) PIAPIEnvironment *environment;

- (void)setEnvironment:(PIAPIEnvironment *)environment isCurrentEnvironment:(BOOL)isCurrentEnvironment;

+ (NSString *) identifier;

@end