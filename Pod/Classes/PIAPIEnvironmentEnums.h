//
//  PIAPIEnvironmentEnums.h
//  Pods
//
//  Created by Julio Rivera on 2/15/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved
//

/**
 Invoke Events currently supported
 */
typedef NS_ENUM(NSInteger, PIAPIEnvironmentInvokeEvent) {
    /**
     *  No event will present the environment view controller, you must present manually
     */
    PIAPIEnvironmentInvokeEventNone,
    /**
     *  Shaking the device will present the environment view controller
     */
    PIAPIEnvironmentInvokeEventShake,
    /*
     *  Swiping two fingers left while in any screen will present the environment view controller
     */
    PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft
};
