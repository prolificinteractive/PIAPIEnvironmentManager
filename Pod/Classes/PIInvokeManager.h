//
//  PIInvokeManager.h
//  Pods
//
//  Created by Christopher Jones on 9/12/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

#import "PIAPIEnvironmentManager.h"
#import "PIAPIEnvironmentEnums.h"

/**
 *  A global interface for displaying the APIEnvironmentManager interface
 *  from anywhere in the application using gestures.
 */
@interface PIInvokeManager : NSObject

/**
 *  Sets the invoke event to display the environment view
 *  along with the environment manager that should be used as the data source.
 *
 *  @param event   The gesture to be used to invoke the event.
 *  @param manager The environment manager to be used to display in the UI.
 */
+ (void)setInvokeEvent:(PIAPIEnvironmentInvokeEvent)event
            forManager:(nonnull PIAPIEnvironmentManager *)manager;

@end
