//
//  LocationGatewayTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/31/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationGateway.h"

@interface LocationGatewayTests : XCTestCase

@end

@implementation LocationGatewayTests

- (void) testLocationGateway {
    LocationGateway *SUT = [LocationGateway new];
    
    // It's important that the location gateway be initialized when the LocationGateway is created,
    // because CLLocationManager's have to be created on a thread with a run loop (i.e. the main thread).
    XCTAssertNotNil(SUT.locationManager);
}
@end
