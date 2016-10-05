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

@interface BusinessesDataControllerTests : XCTestCase
@property (strong, nonatomic) BusinessesDataController *SUT;
@property (nonatomic) double testLatitude;
@property (nonatomic) double testLongitude;
@property (strong, nonatomic) NSArray<Business*> *businesses;
@end

@implementation BusinessesDataControllerTests

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

- (void) setUp {
    [super setUp];
    self.SUT = [BusinessesDataController new];
}

- (void)testInit {
    BusinessesDataController *SUT = self.SUT;
    XCTAssertNotNil(SUT.fourSquareGateway);
}


- (void)testUpdateLocationAndBusinesses {
    // Setup fake LocationGateway
    self.testLatitude = 41.840457;
    self.testLongitude = -87.660502;
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:self.testLatitude]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:self.testLongitude]);
    self.SUT.locationGateway = fakeLocationGateway;
    
    // Setup fake FourSquareGateway
    self.businesses = [self makeBusinesses];
    id fakeFourSquareGateway = OCMClassMock([FourSquareGateway class]);
    self.SUT.fourSquareGateway = fakeFourSquareGateway;
    OCMStub([fakeFourSquareGateway businesses]).andReturn(self.businesses);

    // Setup fake delegate
    id testDelegate = OCMProtocolMock(@protocol(BusinessesDataControllerDelegate));
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
    XCTAssertEqualObjects(self.SUT.businesses, self.businesses);
    XCTAssertNotEqual(self.SUT.businesses,self.businesses);
    OCMVerify([testDelegate businessesDataControllerDidUpdateBusinesses]);
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
    // Setup fake delegate
    id testDelegate = [self setUpForLocationGatewayDidFailTestsWithErrorMessage:@"Unable to retrieve location." errorCode:kBusinessesDataControllerErrorLocation];
    [self.SUT locationGatewayDidFailWithError:nil];
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
