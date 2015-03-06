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

/**
 *  Delegate Method to communicate when a switch has been toggled
 *
 *  @param environmentSwitch UISwitch toggled
 *  @param environment       PIAPIEnvironment that corresponds to the UISwitch toggled
 */
- (void) environmentCellSwitchToggled:(UISwitch *)environmentSwitch
                       forEnvironment:(PIAPIEnvironment *)environment;

@end

@interface PIAPIEnvironmentTableViewCell : UITableViewCell

@property (nonatomic, readwrite, weak) id<PIAPIEnvironmentTableViewCellDelegate> delegate;

@property (nonatomic, readonly, weak) PIAPIEnvironment *environment;

/**
 *  Setter method to update PIAPIEnvironmentTableViewCell with data
 *
 *  @param environment          PIAPIEnvironment to set
 *  @param isCurrentEnvironment BOOL if environment is the current environment
 */
- (void)setEnvironment:(PIAPIEnvironment *)environment isCurrentEnvironment:(BOOL)isCurrentEnvironment;

/**
 *  Method that returns the cell's identifier
 *
 *  @return NSString of the cell's identifier
 */
+ (NSString *) identifier;

@end