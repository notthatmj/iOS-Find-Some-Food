//
//  IntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/29/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesRepository.h"
#import "Business.h"

@interface IntegrationTests : XCTestCase

@end

@implementation IntegrationTests

- (void)testBusinessesRepositoryIntegration {
    BusinessesRepository *SUT = [BusinessesRepository new];
    SUT.fourSquareGateway = [FourSquareGateway new];
    XCTAssertEqual(SUT.businesses.count,0);
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];
    [SUT updateBusinessesAndCallBlock:^{
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {}];
    
    XCTAssertNotNil(SUT.businesses);
    XCTAssert([SUT.businesses count] > 1);
    for (Business *business in SUT.businesses) {
        XCTAssertNotNil(business.name);
    }
    
}

@end
