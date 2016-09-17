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

//- (void)testFetchLocationAndCallBlock {
//    //    // Setup
//    BusinessesDataController *SUT = [BusinessesDataController new];
//    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
//    SUT.locationGateway = fakeLocationGateway;
//    void (^dummyBlock)(void) = ^{}
//    ;
//    [SUT fetchLocationAndCallBlock:dummyBlock];
//    
//    XCTAssertEqualObjects(SUT.block, dummyBlock);
//    OCMVerify([fakeLocationGateway setDelegate:SUT]);
////    XCTAssertEqual(SUT, SUT.locationGateway.delegate);
//    OCMVerify([fakeLocationGateway fetchLocationAndNotifyDelegate]);
//}

//- (void)testFetchLocation {
//    // Setup
//    BusinessesDataController *SUT = [BusinessesDataController new];
//    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
//    SUT.locationGateway = fakeLocationGateway;
//    
//    [SUT fetchLocation];
//    
//    OCMVerify([fakeLocationGateway setDelegate:SUT]);
//    OCMVerify([fakeLocationGateway fetchLocationAndNotifyDelegate]);
//}

- (void)testUpdateLocationAndBusinessesAndCallBlock {
    // Setup
    BusinessesDataController *originalSUT = [BusinessesDataController new];
    BusinessesDataController *SUT = OCMPartialMock(originalSUT);
    FourSquareGateway *fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    SUT.fourSquareGateway = fakeFourSquareGateway;
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    SUT.locationGateway = fakeLocationGateway;
    void (^completionBlock)(void) = ^{};
    
    [SUT updateLocationAndBusinessesAndCallBlock:completionBlock];
    
    OCMVerify([fakeLocationGateway setDelegate:originalSUT]);
    OCMVerify([fakeLocationGateway fetchLocationAndNotifyDelegate]);
    XCTAssertEqual(SUT.block, completionBlock);
//    SUT.block();
//    OCMVerify([SUT updateBusinessesAndCallBlock:[OCMArg any]]);
}

- (void)testLocationGatewayDidUpdateLocation {
    const double testLatitude = 41.840457;
    const double testLongitude = -87.660502;
    
    // Setup
    BusinessesDataController *originalSUT = [BusinessesDataController new];
    BusinessesDataController *SUT = OCMPartialMock(originalSUT);
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:testLatitude]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:testLongitude]);
    SUT.locationGateway = fakeLocationGateway;
    __block BOOL blockWasRun = NO;
    void (^completionBlock)() = ^{
        blockWasRun = YES;
    };
    SUT.block = completionBlock;
    [SUT locationGatewayDidUpdateLocation:nil];
    
    XCTAssertEqual(SUT.latitude, testLatitude);
    XCTAssertEqual(SUT.longitude, testLongitude);
//    XCTAssertTrue(blockWasRun);
    OCMVerify([SUT updateBusinessesAndCallBlock:completionBlock]);
}

- (void)testUpdateBusinessesAndCallBlock {
    // Setup
    const double testLatitude = 41.840457;
    const double testLongitude = -87.660502;

    BusinessesDataController *SUT = [BusinessesDataController new];
    id fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    SUT.fourSquareGateway = fakeFourSquareGateway;
    SUT.latitude = testLatitude;
    SUT.longitude = testLongitude;
    void (^dummyBlock)() = ^{};
    // Run
    [SUT updateBusinessesAndCallBlock:dummyBlock];
    
    // Verify
    OCMVerify([fakeFourSquareGateway getNearbyBusinessesAndNotifyDelegateForLatitude:testLatitude longitude:testLongitude]);
    XCTAssertEqualObjects(SUT.otherBlock, dummyBlock);
//    XCTAssertEqual(SUT.fourSquareGateway.delegate,SUT);
    OCMVerify([SUT.fourSquareGateway setDelegate:SUT]);
}

- (void)testFourSquareGatewayDidFinishGettingBusinesses{
    BusinessesDataController *SUT = [BusinessesDataController new];
    NSArray<Business*> *businesses = [self makeBusinesses];
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    void (^otherBlock)() = ^{
        [expectation fulfill];
    };
    SUT.otherBlock = otherBlock;
    id fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    SUT.fourSquareGateway = fakeFourSquareGateway;
    OCMStub([fakeFourSquareGateway businesses]).andReturn(businesses);
    
    [SUT fourSquareGatewayDidFinishGettingBusinesses];
    
    [self waitForExpectationsWithTimeout:0.0 handler:nil];
    XCTAssertEqualObjects(SUT.businesses, businesses);
    XCTAssertNotEqual(SUT.businesses,businesses);
}

- (NSArray<Business*> *) makeBusinesses {
    NSMutableArray *businesses = [NSMutableArray new];
    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
    for (NSString *businessName in businessNames) {
        Business *business = [Business new];
        business.name = businessName;
        [businesses addObject:business];
    }
    return businesses;
}

@end
