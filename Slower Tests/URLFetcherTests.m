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
@property (strong,nonatomic) NSString *responseString;
@end

@implementation URLFetcherTests

- (NSString *) fetchURLAndWaitForResponse: (NSString *)urlString {
    XCTestExpectation *expectation = [self expectationWithDescription:@"foo"];
    __block NSString *responseString = nil;
    
    [URLFetcher fetchURLContents:urlString completionHandler:^void (NSString *rs){
        responseString = rs;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    return responseString;
}

- (void)testURLFetcherWithGoogle {
    NSString *responseString = [self fetchURLAndWaitForResponse:@"https://www.google.com"];
    XCTAssertTrue([responseString containsString:@"Google Search"]);
}

- (void)testURLFetcherWithDuckDuckGo {
    NSString *responseString = [self fetchURLAndWaitForResponse:@"https://duckduckgo.com"];
    XCTAssertTrue([responseString containsString:@"DuckDuckGo"]);
    XCTAssertTrue([responseString containsString:@"The search engine that doesn't track you."]);
}

@end
