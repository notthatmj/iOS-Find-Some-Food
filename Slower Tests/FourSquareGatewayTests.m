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

@interface FourSquareGatewayTests : XCTestCase
@property (nonatomic,strong) FourSquareGateway *SUT;
@end

@implementation FourSquareGatewayTests

-(void)setUp {
    [super setUp];
    self.SUT = [FourSquareGateway new];
}

- (void)testGetNearbyBusinessForLatitudeLongitude {
    double latitude = 41.884529;
    double longitude = -87.627813;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Getting response"];
    XCTAssertNil(self.SUT.businesses);
    [self.SUT getNearbyBusinessesForLatitude:latitude longitude:longitude completionHandler:^void () {
        [expectation fulfill];
        XCTAssertNotNil(self.SUT.businesses);
        XCTAssert([self.SUT.businesses count] > 1);
        for (Business *business in self.SUT.businesses) {
            XCTAssertNotNil(business.name);
        }
    }];
    [self waitForExpectationsWithTimeout:10.0 handler: ^void (NSError *error) {}];
}

- (void)testFourSquareGateway {
    XCTAssertNotNil(self.SUT.clientID);
    XCTAssertNotNil(self.SUT.clientSecret);
}

-(void)testSearchURLForLatitudeLongitude {
    self.SUT.clientID = @"parrot";
    self.SUT.clientSecret = @"bar";
    NSString *expectedResult = @"https://api.foursquare.com/v2/venues/search?client_id=parrot&client_secret=bar&v=20130815&ll=40.70000,-74.00000&query=sushi";
    NSString *result = [self.SUT searchURLForLatitude:40.7 longitude:-74];
    XCTAssertEqualObjects(result, expectedResult);
}

@end
