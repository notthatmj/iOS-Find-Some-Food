//
//  IntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/29/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesDataController.h"
#import "Business.h"
//#import "FourSquareGatewayTests.m"

@interface IntegrationTests : XCTestCase

@end

@implementation IntegrationTests

- (void)testBusinessesDataControllerIntegration {
    // Setup
    BusinessesDataController *SUT = [BusinessesDataController new];
    XCTAssertEqual(SUT.businesses.count,0);
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];

    // Run
    [SUT updateLocationAndBusinessesAndCallBlock:^{
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {}];
    
    // Verify
    XCTAssertNotNil(SUT.businesses);
    XCTAssert([SUT.businesses count] > 1);
    for (Business *business in SUT.businesses) {
        XCTAssertNotNil(business.name);
    }    
}

@end
