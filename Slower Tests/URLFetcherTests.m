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

- (NSData *) fetchURLDataAndWaitForResponse: (NSString *)urlString {
    XCTestExpectation *expectation = [self expectationWithDescription:@"foo"];
    __block NSData *responseData = nil;
    
    [URLFetcher fetchURLData:urlString completionHandler:^void (NSData *data){
        responseData = data;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    return responseData;
}

- (void)testURLFetcherWithGoogle {
    NSString *responseString = [self fetchURLAndWaitForResponse:@"https://www.google.com"];
    XCTAssertTrue([responseString containsString:@"Google Search"]);
}

- (void)testURLDataFetcherWithGoogle {
    NSData *responseData = [self fetchURLDataAndWaitForResponse:@"https://www.google.com"];
    NSString *responseString;
    [NSString stringEncodingForData:responseData
                    encodingOptions:nil
                    convertedString:&responseString
                usedLossyConversion:nil];

    XCTAssertTrue([responseString containsString:@"Google Search"]);
}

- (void)testURLFetcherWithDuckDuckGo {
    NSString *responseString = [self fetchURLAndWaitForResponse:@"https://duckduckgo.com"];
    XCTAssertTrue([responseString containsString:@"DuckDuckGo"]);
    XCTAssertTrue([responseString containsString:@"The search engine that doesn't track you."]);
}

@end
