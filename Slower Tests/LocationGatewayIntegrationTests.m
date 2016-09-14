//
//  LocationGatewayIntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/14/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationGateway.h"

@interface LocationGatewayIntegrationTests : XCTestCase

@end

@implementation LocationGatewayIntegrationTests

- (void) testLocationGateway {
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

@end
