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

@end

@interface LocationGatewayDidFailWithErrorTests : XCTestCase
@property (nonatomic, strong) LocationGateway *SUT;
@property (nonatomic, strong) id<LocationGatewayDelegate> fakeDelegate;
@property (strong, nonatomic) CLLocationManager *dummyLocationManager;
@property (strong, nonatomic) NSError *dummyError;
@end

@implementation LocationGatewayDidFailWithErrorTests

-(void)setUp {
    self.SUT = [LocationGateway new];
    self.dummyLocationManager = OCMClassMock([CLLocationManager class]);
    self.SUT.locationManager = self.dummyLocationManager;
    self.dummyError = [NSError errorWithDomain:@"dummy" code:0 userInfo:nil];

}

- (void)setFakeDelegate:(id<LocationGatewayDelegate>)fakeDelegate {
    _fakeDelegate = fakeDelegate;
    self.SUT.delegate = fakeDelegate;
}

- (void) testLocationManagerDidFailWithErrorWhenFetching {
    // Setup
    self.fakeDelegate = OCMProtocolMock(@protocol(LocationGatewayDelegate));
    
    // Run
    [self.SUT fetchLocation];
    [self.SUT locationManager:self.dummyLocationManager didFailWithError:self.dummyError];
    
    // Verify
    XCTAssertFalse(self.SUT.fetchingLocation);
    OCMVerify([self.fakeDelegate locationGatewayDidFailWithError:self.dummyError]);
}

- (void) testLocationManagerDidFailWithErrorWhenNotFetching {
    // Setup
    self.fakeDelegate = OCMStrictProtocolMock(@protocol(LocationGatewayDelegate));
    
    // Run
    [self.SUT locationManager:self.dummyLocationManager didFailWithError:self.dummyError];
    XCTAssertFalse(self.SUT.fetchingLocation);
}
@end
