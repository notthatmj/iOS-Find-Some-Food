//
//  ModelTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Model.h"
#import "FourSquareGateway.h"
#import "OCMock.h"
#import "Business.h"
#import "LocationGateway.h"
#import "BusinessFinderErrorDomain.h"

@interface ModelObserverForHappyPathTests : NSObject<ModelObserving>
@property XCTestExpectation *testExpectation;
@end
@implementation ModelObserverForHappyPathTests

-(void)modelDidUpdateBusinesses {
    [self.testExpectation fulfill];
}
-(void)modelDidFailWithError:(NSError *)error {
    [self.testExpectation fulfill];
}
@end

@interface ModelHappyPathTests : XCTestCase
@property (strong, nonatomic) Model *SUT;
@property (nonatomic) double testLatitude;
@property (nonatomic) double testLongitude;
@property (nonatomic, strong) UIImage *testImage;
@property (nonatomic, strong) ModelObserverForHappyPathTests *testDelegate;
@end

@implementation ModelHappyPathTests

- (void) setUp {
    [super setUp];
    self.SUT = [Model new];
    [self setupFakeLocationGateway];
}

- (void) setupFakeLocationGateway {
    self.testLatitude = 41.840457;
    self.testLongitude = -87.660502;
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:self.testLatitude]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:self.testLongitude]);
    self.SUT.locationGateway = fakeLocationGateway;
}

- (void) setupFakeFourSquareGatewayWithBusinesses:(NSArray<Business *>*) businesses {
    FourSquareGateway *fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    self.SUT.fourSquareGateway = fakeFourSquareGateway;
    OCMStub([fakeFourSquareGateway businesses]).andReturn(businesses);
    self.testImage = [UIImage imageNamed:@"A"
                                inBundle:[NSBundle bundleForClass:[self class]]
           compatibleWithTraitCollection:nil];
    id completionHandlerArg = [OCMArg invokeBlockWithArgs:self.testImage,nil];
    OCMStub([fakeFourSquareGateway downloadFirstPhotoForVenueID:[OCMArg any] completionHandler:completionHandlerArg]);
}

- (void)testUpdateLocationAndBusinesses {
    // Run
    [self.SUT updateLocationAndBusinesses];
    
    // Verify
    OCMVerify([self.SUT.locationGateway setDelegate:self.SUT]);
    OCMVerify([self.SUT.locationGateway fetchLocation]);
}

- (void)testLocationGatewayDidUpdateLocation {
    // Setup
    [self setupFakeFourSquareGatewayWithBusinesses:@[]];
    [self.SUT updateLocationAndBusinesses];
    
    // Run
    [self.SUT locationGatewayDidUpdateLocation:nil];
    
    // Verify
    XCTAssertEqual(self.SUT.userLatitude, self.testLatitude);
    XCTAssertEqual(self.SUT.userLongitude, self.testLongitude);
    OCMVerify([self.SUT.fourSquareGateway setDelegate:self.SUT]);
    OCMVerify([self.SUT.fourSquareGateway getNearbyBusinessesForLatitude:self.testLatitude
                                                               longitude:self.testLongitude]);
}

- (void) setupTestDelegate {
    ModelObserverForHappyPathTests *testDelegate = [ModelObserverForHappyPathTests new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectation"];
    testDelegate.testExpectation = expectation;
    self.SUT.observer = testDelegate;
    // We need to keep a strong refrence to testDelegate to keep it alive until the end of the test
    self.testDelegate = testDelegate;
}

- (void)testFourSquareGatewayDidFinishGettingBusinesses {
    NSMutableArray *businesses = [NSMutableArray new];
    [businesses addObject:[[Business alloc] initWithName:@"Trader Joe's" distance:1.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Aldi" distance:2.0]];
    [self setupFakeFourSquareGatewayWithBusinesses: businesses];
    
    [self setupTestDelegate];
    [self.SUT updateLocationAndBusinesses];
    [self.SUT locationGatewayDidUpdateLocation:nil];
    
    // Run
    [self.SUT fourSquareGatewayDidFinishGettingBusinesses];
    
    // Verify
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    for (Business *business in self.SUT.businesses) {
        XCTAssertEqualObjects(business.image, self.testImage);
    }
    XCTAssertEqualObjects(self.SUT.businesses, businesses);
}

- (void)testFourSquareGatewayDidFinishGettingBusinessesSortsByDistance {
    NSMutableArray *businesses = [NSMutableArray new];
    [businesses addObject:[[Business alloc] initWithName:@"McDonald's" distance:5.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Burger King" distance:1.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Taco Bell" distance:3.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Wendy's" distance:2.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Popeyes" distance:4.0]];
    [self setupFakeFourSquareGatewayWithBusinesses: businesses];
    
    [self setupTestDelegate];
    [self.SUT updateLocationAndBusinesses];
    [self.SUT locationGatewayDidUpdateLocation:nil];
    
    // Run
    [self.SUT fourSquareGatewayDidFinishGettingBusinesses];
    
    // Verify
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    XCTAssertEqualObjects(self.SUT.businesses[0].name,@"Burger King");
    XCTAssertEqualObjects(self.SUT.businesses[1].name,@"Wendy's");
    XCTAssertEqualObjects(self.SUT.businesses[2].name,@"Taco Bell");
    XCTAssertEqualObjects(self.SUT.businesses[3].name,@"Popeyes");
    XCTAssertEqualObjects(self.SUT.businesses[4].name,@"McDonald's");
}
@end

@interface ModelFailureTests : XCTestCase
@property (strong, nonatomic) Model *SUT;
@end

@implementation ModelFailureTests
- (void) setUp {
    [super setUp];
    self.SUT = [Model new];
}

- (void)testInit {
    XCTAssertNotNil(self.SUT.fourSquareGateway);
}

- (id)setUpForLocationGatewayDidFailTestsWithErrorMessage:(NSString *)descriptionString errorCode:(int)errorCode {
    BOOL (^errorCheckBlock) (id obj) = ^BOOL(id obj) {
        NSError *error = obj;
        if ([error.domain isEqualToString:kBusinessFinderErrorDomain] &&
            error.code == errorCode &&
            [error.localizedDescription isEqualToString: NSLocalizedString(descriptionString, @"")]){
            return true;
        }
        return false;
    };
    
    id testDelegate = OCMStrictProtocolMock(@protocol(ModelObserving));
    OCMExpect([testDelegate modelDidFailWithError:[OCMArg checkWithBlock:errorCheckBlock]]);
    self.SUT.observer = testDelegate;
    return testDelegate;
}

- (void)testLocationGatewayDidFailWithError_UnableToRetrieve {
    id testDelegate = [self setUpForLocationGatewayDidFailTestsWithErrorMessage:@"Unable to retrieve location." errorCode:kModelErrorLocation];
    NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
    [self.SUT locationGatewayDidFailWithError:error];
    OCMVerifyAll(testDelegate);
}

- (void)testLocationGatewayDidFailWithError_AuthorizationDenied {
    id testDelegate = [self setUpForLocationGatewayDidFailTestsWithErrorMessage:@"Please enable location services in your device settings." errorCode:kModelErrorLocationPermissionDenied];
    NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
    [self.SUT locationGatewayDidFailWithError:error];
    OCMVerifyAll(testDelegate);
}

- (void)testFourSquareGatewayDidFail {
    // Setup fake delegate
    id testDelegate = OCMProtocolMock(@protocol(ModelObserving));
    self.SUT.observer = testDelegate;
    
    [self.SUT fourSquareGatewayDidFail];
    OCMVerify([testDelegate modelDidFailWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSError *error = obj;
        if ([error.domain isEqualToString:kBusinessFinderErrorDomain] &&
            error.code == kModelErrorServer &&
            [error.localizedDescription isEqualToString: NSLocalizedString(@"Unable to retrieve businesses from the server.", @"")]){
            return true;
        }
        return false;
    }]]);
}

@end

