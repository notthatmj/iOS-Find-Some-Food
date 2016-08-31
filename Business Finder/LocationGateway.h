//
//  LocationGateway.h
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocationManager;

/**
 LocationGateway delegates its tasks to a CLLocationManager. According to the
 "Core Location Best Practices" video from WWDC 2016, a CLLocationManager
 instance must be created on a thread with a run loop (such asthe main thread);
 it's also recommended to only interact with the LocationManager from that
 thread. So we initialize the locationManager when the LocationGateway is
 created, and use the same rules when interacting with the LocationGateway.
 */
@interface LocationGateway : NSObject
@property (strong, nonatomic,readonly) CLLocationManager *locationManager;
@end
