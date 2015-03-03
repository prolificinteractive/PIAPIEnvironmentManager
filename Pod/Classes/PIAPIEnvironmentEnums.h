//
//  PIAPIEnvironmentEnums.h
//  Pods
//
//  Created by Julio Rivera on 2/15/15.
//
//

/**
 Invoke Events currently supported
 */
typedef enum PIAPIEnvironmentInvokeEvent {
    /**
     *  No event will present the environment view controller, you must handle yourself
     */
    PIAPIEnvironmentInvokeEventNone,
    /**
     *  Shaking the device will present the environment view controller
     */
    PIAPIEnvironmentInvokeEventShake,
    /*
     *  Swiping two fingers left while in any screen will present the environment view controller
     */
    PIAPIEnvironmentInvokeEventTwoFingersSwipeLeft,
} PIAPIEnvironmentInvokeEvent;
