//
//  BusinessesDataControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesDataController.h"
#import "FourSquareGateway.h"
#import "OCMock.h"
#import "Business.h"
#import "LocationGateway.h"

@interface BusinessesDataControllerTests : XCTestCase

@end

@implementation BusinessesDataControllerTests

- (void)testInit {
    BusinessesDataController *SUT = [BusinessesDataController new];
    XCTAssertNotNil(SUT.fourSquareGateway);
}

//- (void)testUpdateLocationAndBusinessesAndCallBlock {
//    // Setup
//    BusinessesDataController *SUT = [BusinessesDataController new];
//    
//    // Setup fakeLocationGateway.
//    const double testLatitude = 41.840457;
//    const double testLongitude = -87.660502;
//    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
////    OCMStub([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg invokeBlock]]);
//    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:testLatitude]);
//    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:testLongitude]);
//    SUT.locationGateway = fakeLocationGateway;
//    
//    // Setup fake FourSquareGatway
//    NSMutableArray *businesses = [NSMutableArray new];
//    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
//    for (NSString *businessName in businessNames) {
//        Business *business = [Business new];
//        business.name = businessName;
//        [businesses addObject:business];
//    }
//    id fourSquareGateway = OCMClassMock([FourSquareGateway class]);
//    OCMStub([fourSquareGateway businesses]).andReturn(businesses);
//    SUT.fourSquareGateway = fourSquareGateway;
//    OCMStub([fourSquareGateway getNearbyBusinessesForLatitude:testLatitude
//                                                      longitude:testLongitude
//                                              completionHandler:[OCMArg invokeBlock]]);
//    
//    // Run
//    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];
//    [SUT updateLocationAndBusinessesAndCallBlock:^{
//        [expectation fulfill];
//    }];
//
//    // Everything is mocked up in this test so nothing is actually asynchronous, which is why we give a timeout of 0.0 here.
//    [self waitForExpectationsWithTimeout:0.0 handler:nil];
//    
////    OCMVerify([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg any]]);
//    XCTAssertEqual(SUT.latitude, testLatitude);
//    XCTAssertEqual(SUT.longitude, testLongitude);
//    OCMVerify([[fourSquareGateway ignoringNonObjectArgs] getNearbyBusinessesForLatitude:testLatitude
//                                                                              longitude:testLongitude
//                                                                      completionHandler:[OCMArg any]]);
//    
//    XCTAssertEqual([SUT.businesses count],2);
//    XCTAssertEqualObjects(SUT.businesses[0].name, businessNames[0]);
//    XCTAssertEqualObjects(SUT.businesses[1].name, businessNames[1]);
//}

- (void)testUpdateLocationAndBusinessesAndCallBlock {
    //    // Setup
    BusinessesDataController *SUT = [BusinessesDataController new];
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    SUT.locationGateway = fakeLocationGateway;
    void (^dummyBlock)(void) = ^{}
    ;
    [SUT fetchLocationAndCallBlock:dummyBlock];
    
    XCTAssertEqualObjects(SUT.block, dummyBlock);
    OCMVerify([fakeLocationGateway setDelegate:SUT]);
//    XCTAssertEqual(SUT, SUT.locationGateway.delegate);
    OCMVerify([fakeLocationGateway fetchLocationAndNotifyDelegate]);
}

- (void)testLocationGatewayDidUpdateLocation {
    const double testLatitude = 41.840457;
    const double testLongitude = -87.660502;
    
    // Setup
    BusinessesDataController *SUT = [BusinessesDataController new];
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:testLatitude]);
    
    [SUT locationGatewayDidUpdateLocation:nil];
}

@end
