//
//  LocationFinderTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationFinder.h"

@interface LocationFinderTests : XCTestCase

@end

@implementation LocationFinderTests

- (void)testLocationFinder {
    LocationFinder *locationFinder = [LocationFinder new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    
    XCTAssertEqual(locationFinder.latitude, 0);
    XCTAssertEqual(locationFinder.longitude, 0);
    
    [locationFinder fetchLocationAndCallBlock:^{
        [expectation fulfill];
    }];
    
    XCTAssertNotEqual(locationFinder.latitude,0);
    XCTAssertNotEqual(locationFinder.longitude,0);
}
@end