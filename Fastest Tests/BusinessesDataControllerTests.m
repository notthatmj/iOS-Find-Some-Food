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

- (void)testLocationGatewayDidFailWithError {
    // Setup fake delegate
    id testDelegate = OCMProtocolMock(@protocol(BusinessesDataControllerDelegate));
    self.SUT.delegate = testDelegate;
    
    [self.SUT locationGatewayDidFailWithError:nil];
    OCMVerify([testDelegate businessesDataControllerDidFailWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSError *error = obj;
        if ([error.domain isEqualToString:kBusinessFinderErrorDomain] &&
            error.code == kBusinessesDataControllerErrorLocation &&
            [error.localizedDescription isEqualToString: NSLocalizedString(@"Unable to retrieve location.", @"")]){
            return true;
        }
        return false;
    }]]);
}

- (void)testLocationGatewayDidFailWithError_AuthorizationDenied {
    // Setup fake delegate
    id testDelegate = OCMProtocolMock(@protocol(BusinessesDataControllerDelegate));
    self.SUT.delegate = testDelegate;
    NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
    
    [self.SUT locationGatewayDidFailWithError:error];
    OCMVerify([testDelegate businessesDataControllerDidFailWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSError *error = obj;
        if ([error.domain isEqualToString:kBusinessFinderErrorDomain] &&
            error.code == kBusinessesDataControllerErrorLocationPermissionDenied &&
            [error.localizedDescription isEqualToString: NSLocalizedString(@"Please enable location services in your device settings.", @"")]){
            return true;
        }
        return false;
    }]]);
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
