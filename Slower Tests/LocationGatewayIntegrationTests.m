//
//  LocationGatewayIntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/14/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationGateway.h"

@interface LocationGatewayTestDelegate : NSObject<LocationGatewayDelegate>
@property (strong,nonatomic) XCTestExpectation *expectation;
@end

@implementation LocationGatewayTestDelegate
-(void)locationGatewayDidUpdateLocation:(LocationGateway *)locationGateway {
    [self.expectation fulfill];
}
@end
@interface LocationGatewayIntegrationTests : XCTestCase
@end

@implementation LocationGatewayIntegrationTests

- (void) testFetchLocation {
    LocationGateway *SUT = [LocationGateway new];
    LocationGatewayTestDelegate *delegate = [LocationGatewayTestDelegate new];
    delegate.expectation = [self expectationWithDescription:@"expectation"];
    SUT.delegate = delegate;
    
    XCTAssertNil(SUT.latitude);
    XCTAssertNil(SUT.longitude);
    [SUT fetchLocation];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertNotNil(SUT.latitude);
    XCTAssertNotNil(SUT.longitude);
}

@end
