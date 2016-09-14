//
//  LocationGatewayTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/31/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationGateway.h"

@interface LocationGatewayUnitTests : XCTestCase

@end

@implementation LocationGatewayUnitTests

- (void) testLocationManagerInitialization {
    LocationGateway *SUT = [LocationGateway new];
    
    // It's important that the location gateway be initialized when the LocationGateway is created,
    // because CLLocationManager's have to be created on a thread with a run loop (i.e. the main thread).
    XCTAssertNotNil(SUT.locationManager);
}

- (void) testLocationManagerDidUpdateLocations {
    LocationGateway *SUT = [LocationGateway new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.758684 longitude:-73.985163];

    [SUT locationManager:nil didUpdateLocations:@[location]];
    
    XCTAssertEqual([SUT.latitude doubleValue], 40.758684);
    XCTAssertEqual([SUT.longitude doubleValue], -73.985163);
}

- (void) testInfoPlistKey {
    NSString *locationPrompt = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
    XCTAssertNotNil(locationPrompt);
}

@end
