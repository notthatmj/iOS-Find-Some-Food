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

- (void) testLocationGateway1 {
    LocationGateway *SUT = [LocationGateway new];
    
    // It's important that the location gateway be initialized when the LocationGateway is created,
    // because CLLocationManager's have to be created on a thread with a run loop (i.e. the main thread).
    XCTAssertNotNil(SUT.locationManager);
}

- (void) testLocationGateway2 {
    LocationGateway *SUT = [LocationGateway new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    XCTAssertNil(SUT.latitude);
    XCTAssertNil(SUT.longitude);
    [SUT fetchLocationAndCallBlock:^(){
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertNotNil(SUT.latitude);
    XCTAssertNotNil(SUT.longitude);
}

- (void) testLocationGateway3 {
    LocationGateway *SUT = [LocationGateway new];

    CLAuthorizationStatus status = [LocationGateway authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined){
        [SUT requestWhenInUseAuthorization];
    }
}

- (void) testInfoPlistKey {
    NSString *locationPrompt = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
    XCTAssertNotNil(locationPrompt);
}


@end
