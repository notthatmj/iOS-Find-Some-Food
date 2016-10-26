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
@property (strong,nonatomic) NSError *error;
@end

@implementation URLFetcherTests

- (void) fetchDataForURLStringAndWaitForResponse: (NSString *)urlString {
    XCTestExpectation *expectation = [self expectationWithDescription:@"foo"];
    __block NSData *responseData = nil;
    __block NSError *responseError = nil;
    [URLFetcher fetchDataForURLString:urlString completionHandler:^void (NSData *data,NSError *error){
        responseData = data;
        responseError = error;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:120.0 handler:nil];
    NSString *responseString;
    [NSString stringEncodingForData:responseData
                    encodingOptions:nil
                    convertedString:&responseString
                usedLossyConversion:nil];
    self.responseString = responseString;
    self.error = responseError;
}

- (void)testFetchDataForURLStringCompletionHandlerWithGoogle {
    [self fetchDataForURLStringAndWaitForResponse:@"https://www.google.com"];
    
    XCTAssertTrue([self.responseString containsString:@"Google Search"]);
    XCTAssertNil(self.error);
}

- (void)testFetchDataForURLStringCompletionHandlerWithDuckDuckGo {
    
    [self fetchDataForURLStringAndWaitForResponse:@"https://duckduckgo.com"];
    
    XCTAssertTrue([self.responseString containsString:@"DuckDuckGo"]);
    XCTAssertTrue([self.responseString containsString:@"The search engine that doesn't track you."]);
    XCTAssertNil(self.error);
}

- (void)testFetchDataForURLStringCompletionHandlerWithBadURL {
    
    [self fetchDataForURLStringAndWaitForResponse:@"This is not a url"];

    XCTAssertNil(self.responseString);
    XCTAssertNotNil(self.error);
    XCTAssertEqualObjects(self.error.domain,NSURLErrorDomain);
}

@end
