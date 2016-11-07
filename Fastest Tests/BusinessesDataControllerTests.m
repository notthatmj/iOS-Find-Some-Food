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
#import "BusinessFinderErrorDomain.h"

@interface BDCDelegateForHappyPathTests : NSObject<BusinessesDataControllerDelegate>
@property XCTestExpectation *testExpectation;
@end
@implementation BDCDelegateForHappyPathTests

-(void)businessesDataControllerDidUpdateBusinesses {
    [self.testExpectation fulfill];
}
-(void)businessesDataControllerDidFailWithError:(NSError *)error {
    [self.testExpectation fulfill];
}
@end

@interface BusinessesDataControllerHappyPathTests : XCTestCase
@property (strong, nonatomic) BusinessesDataController *SUT;
@property (nonatomic) double testLatitude;
@property (nonatomic) double testLongitude;
@property (strong, nonatomic) NSArray<Business*> *businesses;
@end

@implementation BusinessesDataControllerHappyPathTests

- (void) setUp {
    [super setUp];
    self.SUT = [BusinessesDataController new];
}

- (void) runAndVerifyHappyPath {
    // Setup fake LocationGateway
    self.testLatitude = 41.840457;
    self.testLongitude = -87.660502;
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:self.testLatitude]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:self.testLongitude]);
    self.SUT.locationGateway = fakeLocationGateway;
    
    // Setup fake FourSquareGateway
    FourSquareGateway *fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    self.SUT.fourSquareGateway = fakeFourSquareGateway;
    OCMStub([fakeFourSquareGateway businesses]).andReturn(self.businesses);
    UIImage *testImage = [UIImage imageNamed:@"A"
                                 inBundle:[NSBundle bundleForClass:[self class]]
            compatibleWithTraitCollection:nil];
    id completionHandlerArg = [OCMArg invokeBlockWithArgs:testImage,nil];
    OCMStub([fakeFourSquareGateway downloadFirstPhotoForVenueID:[OCMArg any] completionHandler:completionHandlerArg]);
    BDCDelegateForHappyPathTests *testDelegate = [BDCDelegateForHappyPathTests new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectation"];
    testDelegate.testExpectation = expectation;
    self.SUT.delegate = testDelegate;
    
    // Run
    [self.SUT updateLocationAndBusinesses];
    
    // Verify
    OCMVerify([self.SUT.locationGateway setDelegate:self.SUT]);
    OCMVerify([self.SUT.locationGateway fetchLocation]);
    
    // Run
    [self.SUT locationGatewayDidUpdateLocation:nil];
    
    // Verify
    XCTAssertEqual(self.SUT.latitude, self.testLatitude);
    XCTAssertEqual(self.SUT.longitude, self.testLongitude);
    OCMVerify([self.SUT.fourSquareGateway setDelegate:self.SUT]);
    OCMVerify([self.SUT.fourSquareGateway getNearbyBusinessesForLatitude:self.testLatitude
                                                               longitude:self.testLongitude]);
    
    [self.SUT fourSquareGatewayDidFinishGettingBusinesses];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    for (Business *business in self.SUT.businesses) {
        XCTAssertEqualObjects(business.image, testImage);
    }
}

- (void)testUpdateLocationAndBusinesses1 {
    NSMutableArray *businesses = [NSMutableArray new];
    [businesses addObject:[[Business alloc] initWithName:@"Trader Joe's" distance:1.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Aldi" distance:2.0]];
    self.businesses = businesses;
    
    [self runAndVerifyHappyPath];
    XCTAssertEqualObjects(self.SUT.businesses, self.businesses);
        XCTAssertEqualObjects(self.SUT.businesses[0].name,@"Trader Joe's");
        XCTAssertEqualObjects(self.SUT.businesses[1].name,@"Aldi");
}

- (void)testUpdateLocationAndBusinesses2 {
    NSMutableArray *businesses = [NSMutableArray new];
    [businesses addObject:[[Business alloc] initWithName:@"Trader Joe's" distance:2.0]];
    [businesses addObject:[[Business alloc] initWithName:@"Aldi" distance:1.0]];
    self.businesses = businesses;
    
    [self runAndVerifyHappyPath];
    XCTAssertEqualObjects(self.SUT.businesses[0].name,@"Aldi");
    XCTAssertEqualObjects(self.SUT.businesses[1].name,@"Trader Joe's");
}
@end

@interface BusinessesDataControllerTests : XCTestCase
@property (strong, nonatomic) BusinessesDataController *SUT;
@end

@implementation BusinessesDataControllerTests
- (void) setUp {
    [super setUp];
    self.SUT = [BusinessesDataController new];
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
    
    id testDelegate = OCMStrictProtocolMock(@protocol(BusinessesDataControllerDelegate));
    OCMExpect([testDelegate businessesDataControllerDidFailWithError:[OCMArg checkWithBlock:errorCheckBlock]]);
    self.SUT.delegate = testDelegate;
    return testDelegate;
}

- (void)testLocationGatewayDidFailWithError_UnableToRetrieve {
    id testDelegate = [self setUpForLocationGatewayDidFailTestsWithErrorMessage:@"Unable to retrieve location." errorCode:kBusinessesDataControllerErrorLocation];
    NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
    [self.SUT locationGatewayDidFailWithError:error];
    OCMVerifyAll(testDelegate);
}

- (void)testLocationGatewayDidFailWithError_AuthorizationDenied {
    id testDelegate = [self setUpForLocationGatewayDidFailTestsWithErrorMessage:@"Please enable location services in your device settings." errorCode:kBusinessesDataControllerErrorLocationPermissionDenied];
    NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
    [self.SUT locationGatewayDidFailWithError:error];
    OCMVerifyAll(testDelegate);
}

- (void)testFourSquareGatewayDidFail {
    // Setup fake delegate
    id testDelegate = OCMProtocolMock(@protocol(BusinessesDataControllerDelegate));
    self.SUT.delegate = testDelegate;
    
    [self.SUT fourSquareGatewayDidFail];
    OCMVerify([testDelegate businessesDataControllerDidFailWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSError *error = obj;
        if ([error.domain isEqualToString:kBusinessFinderErrorDomain] &&
            error.code == kBusinessesDataControllerErrorServer &&
            [error.localizedDescription isEqualToString: NSLocalizedString(@"Unable to retrieve businesses from the server.", @"")]){
            return true;
        }
        return false;
    }]]);
}

@end

