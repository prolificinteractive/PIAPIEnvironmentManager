//
//  PIAPIEnvironmentObject.h
//  Pods
//
//  Created by Julio Rivera on 8/22/15.
//
//

/**
 *  Protocol that your environment model class must conform to
 */
@protocol PIAPIEnvironmentObject <NSObject>

@required

/**
 *  NSURL of your environment
 *
 *  @return NSString
 */
- (NSURL *)baseURL;

/**
 *  Name of your environment. This will display in the UI.
 *
 *  @return NSString
 */
- (NSString *)name;

/**
 *  Summary of your environment. This will display in the UI.
 *
 *  @return NSString
 */
- (NSString *)summary;

/**
 *  BOOL to to determine if this environment will be the default one selected.
 *
 * @return BOOL
 */
- (BOOL)isDefaultEnvironment;

@end