//
//  PIAPIEnvironmentTableViewCell.h
//  Pods
//
//  Created by Julio Rivera on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@class PIAPIEnvironment;

@interface PIAPIEnvironmentTableViewCell : UITableViewCell

@property (nonatomic, weak) PIAPIEnvironment *environment;

+ (NSString *) identifier;

@end
