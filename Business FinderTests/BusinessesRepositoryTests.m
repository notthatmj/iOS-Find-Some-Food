//
//  BusinessesRepositoryTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesRepository.h"
#import "FourSquareGateway.h"
#import "OCMock.h"
#import "Business.h"
#import "LocationGateway.h"

@interface BusinessesRepositoryTests : XCTestCase

@end

@implementation BusinessesRepositoryTests

- (void)testBusinessesRepository {
    // Setup
    BusinessesRepository *SUT = [BusinessesRepository new];
    const double testLatitude = 41.840457;
    const double testLongitude = -87.660502;
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:testLatitude]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:testLongitude]);
    SUT.locationGateway = fakeLocationGateway;
    
    NSMutableArray *businesses = [NSMutableArray new];
    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
    for (NSString *businessName in businessNames) {
        Business *business = [Business new];
        business.name = businessName;
        [businesses addObject:business];
    }
    id fourSquareGateway = OCMClassMock([FourSquareGateway class]);
    OCMStub([fourSquareGateway businesses]).andReturn(businesses);
    OCMStub([fourSquareGateway getNearbyBusinessesForLatitude:testLatitude
                                                    longitude:testLongitude
                                            completionHandler:[OCMArg invokeBlock]]);
    SUT.fourSquareGateway = fourSquareGateway;
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];

    // Run
    [SUT updateBusinessesAndCallBlock:^{
        [expectation fulfill];
    }];
//
//    // Verify
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {}];
    OCMVerify([fourSquareGateway getNearbyBusinessesForLatitude:testLatitude
                                                      longitude:testLongitude
                                              completionHandler:[OCMArg any]]);
    XCTAssertEqual([SUT.businesses count],2);
    XCTAssertEqualObjects(SUT.businesses[0].name, businessNames[0]);
    XCTAssertEqualObjects(SUT.businesses[1].name, businessNames[1]);
}

- (void)testInit {
    BusinessesRepository *SUT = [BusinessesRepository new];
    XCTAssertNotNil(SUT.fourSquareGateway);
}

@end
