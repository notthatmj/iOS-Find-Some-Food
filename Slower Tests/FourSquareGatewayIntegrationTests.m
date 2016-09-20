//
//  FourSquareGatewayTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/8/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquareGateway.h"
#import "URLFetcher.h"
#import "Business.h"

@interface FourSquareGatewayIntegrationTests : XCTestCase<FourSquareGatewayDelegate>
@property (nonatomic,strong) FourSquareGateway *SUT;
@property (nonatomic,strong) XCTestExpectation *expectation;
@end

@implementation FourSquareGatewayIntegrationTests

-(void)setUp {
    [super setUp];
    self.SUT = [FourSquareGateway new];
}

- (void)testGetNearbyBusinessForLatitudeLongitude {
    double latitude = 41.884529;
    double longitude = -87.627813;
    self.expectation = [self expectationWithDescription:@"expectation"];
    self.SUT.delegate = self;
    [self.SUT getNearbyBusinessesForLatitude:latitude longitude:longitude];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    XCTAssertNotNil(self.SUT.businesses);
    XCTAssert([self.SUT.businesses count] > 1);
    for (Business *business in self.SUT.businesses) {
        XCTAssertNotNil(business.name);
    }
}

-(void)fourSquareGatewayDidFinishGettingBusinesses {
    [self.expectation fulfill];
}
@end
