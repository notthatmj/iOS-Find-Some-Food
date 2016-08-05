//
//  URLFetcherTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/5/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLFetcher.h"

@interface URLFetcherTests : XCTestCase

@end

@implementation URLFetcherTests

- (void)testURLFetcher {
    NSString * __block responseString = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"foo"];
    
    [URLFetcher fetchURLContents:@"https://www.google.com" completionHandler:^void (NSString *rs){
        responseString = rs;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertTrue([responseString hasPrefix:@"<!doctype html>"]);
    XCTAssertNotNil(responseString);
}

@end
