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

@interface FourSquareGatewayTests : XCTestCase

@end

@implementation FourSquareGatewayTests

- (void)testFourSquareGateway {
    FourSquareGateway *SUT = [FourSquareGateway new];
    
    double latitude = 41.884529;
    double longitude = -87.627813;
    
    __block Boolean blockWasRun = NO;
    XCTAssertNil(SUT.businesses);
    [SUT getNearbyBusinessesForLatitude:latitude longitude:longitude completionHandler:^void () {
        blockWasRun = YES;
    }];
    XCTAssertTrue(blockWasRun);
}

-(void)testSearchURLForLatitudeLongitude {
    FourSquareGateway *SUT = [FourSquareGateway new];
    SUT.clientID = @"foo";
    SUT.clientSecret = @"bar";
    NSString *expectedResult = @"https://api.foursquare.com/v2/venues/search?client_id=foo&client_secret=bar&v=20130815&ll=40.70000,-74.00000&query=sushi";
    NSString *result = [SUT searchURLForLatitude:40.7 longitude:-74];
    XCTAssertEqualObjects(result, expectedResult);
}

-(void)testGetResponseForSearchURL {
    FourSquareGateway *SUT = [FourSquareGateway new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Getting response"];
    NSString *searchURL = @"https://api.foursquare.com/v2/venues/search?client_id=KYZDFPBI4QBZA5RYW0KHIARABCHACXQU55CVJLHR3YFKLB0B&client_secret=F40OVIFWPTKBVTKO4LWU13F5JLOZHNPIB1DW1XU2UFBDLXXZ&v=20130815&ll=40.70000,-74.00000&query=sushi";
    NSString __block *response = nil;
    
    XCTAssertNil(response);
    [SUT getResponseForSearchURL:searchURL completionHandler:^void {
        response = [SUT.response copy];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler: ^void (NSError *error) {}];
              
    XCTAssertNotNil(response);
    XCTAssertTrue([response containsString:@"venues"]);
}

-(void)testParseQueryResponse {
    FourSquareGateway *SUT = [FourSquareGateway new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Getting response"];
    NSString *searchURL = @"https://api.foursquare.com/v2/venues/search?client_id=KYZDFPBI4QBZA5RYW0KHIARABCHACXQU55CVJLHR3YFKLB0B&client_secret=F40OVIFWPTKBVTKO4LWU13F5JLOZHNPIB1DW1XU2UFBDLXXZ&v=20130815&ll=40.70000,-74.00000&query=sushi";
    NSString __block *response = nil;
    XCTAssertNil(response);
    [SUT getResponseForSearchURL:searchURL completionHandler:^void {
        response = [SUT.response copy];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler: ^void (NSError *error) {}];
    XCTAssertNotNil(response);

    NSArray<Business *> *parsedResults = [SUT parseQueryResponse];
    XCTAssertNotEqual([parsedResults count], 0);
    Business *business = [parsedResults objectAtIndex:0];
}
@end
