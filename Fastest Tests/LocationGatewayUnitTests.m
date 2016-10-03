//
//  LocationGatewayTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/31/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationGateway.h"
#import "OCMock.h"

@interface LocationGatewayUnitTests : XCTestCase
@property (nonatomic, strong) LocationGateway *SUT;
@end

@implementation LocationGatewayUnitTests

-(void)setUp {
    self.SUT = [LocationGateway new];
}
- (void) testLocationManagerInitialization {
    // It's important that the location gateway be initialized when the LocationGateway is created,
    // because CLLocationManager's have to be created on a thread with a run loop (i.e. the main thread).
    XCTAssertNotNil(self.SUT.locationManager);
    XCTAssertFalse(self.SUT.fetchingLocation);
}

- (void) testLocationManagerDidUpdateLocations {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.758684 longitude:-73.985163];

    [self.SUT locationManager:nil didUpdateLocations:@[location]];
    
    XCTAssertEqual([self.SUT.latitude doubleValue], 40.758684);
    XCTAssertEqual([self.SUT.longitude doubleValue], -73.985163);
}

- (void) testInfoPlistKey {
    NSString *locationPrompt = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
    XCTAssertNotNil(locationPrompt);
}

- (void) testFetchLocation {
    [self.SUT fetchLocation];
    XCTAssertTrue(self.SUT.fetchingLocation);
}

- (void) testFetchingLocation {
    id<LocationGatewayDelegate> fakeDelegate = OCMProtocolMock(@protocol(LocationGatewayDelegate));
    self.SUT.delegate = fakeDelegate;
    CLLocationManager *dummyLocationManager = OCMClassMock([CLLocationManager class]);
    NSError *dummyError = [NSError errorWithDomain:@"dummy" code:0 userInfo:nil];

    XCTAssertFalse(self.SUT.fetchingLocation);
    [self.SUT fetchLocation];
    XCTAssertTrue(self.SUT.fetchingLocation);
    [self.SUT locationManager:dummyLocationManager didFailWithError:dummyError];
    XCTAssertFalse(self.SUT.fetchingLocation);
}
@end

@interface LocationGatewayUnitTests2 : XCTestCase
@property (nonatomic, strong) LocationGateway *SUT;
@end

@implementation LocationGatewayUnitTests2

-(void)setUp {
    self.SUT = [LocationGateway new];
}

- (void) testLocationManagerDidFailWithErrorWhenFetching {
    // Setup
    id<LocationGatewayDelegate> fakeDelegate = OCMProtocolMock(@protocol(LocationGatewayDelegate));
    self.SUT.delegate = fakeDelegate;
    CLLocationManager *dummyLocationManager = OCMClassMock([CLLocationManager class]);
    NSError *dummyError = [NSError errorWithDomain:@"dummy" code:0 userInfo:nil];
    
    // Run
    [self.SUT fetchLocation];
    [self.SUT locationManager:dummyLocationManager didFailWithError:dummyError];
    
    // Verify
    OCMVerify([fakeDelegate locationGatewayDidFailWithError:dummyError]);
}

- (void) testLocationManagerDidFailWithErrorWhenNotFetching {
    // Setup
    id<LocationGatewayDelegate> fakeDelegate = OCMStrictProtocolMock(@protocol(LocationGatewayDelegate));
    self.SUT.delegate = fakeDelegate;
    CLLocationManager *dummyLocationManager = OCMClassMock([CLLocationManager class]);
    self.SUT.locationManager = dummyLocationManager;
    NSError *dummyError = [NSError errorWithDomain:@"dummy" code:0 userInfo:nil];
    
    // Run
    [self.SUT locationManager:dummyLocationManager didFailWithError:dummyError];
    
}
@end
