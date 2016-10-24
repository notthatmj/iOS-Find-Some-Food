//
//  Slowest_Tests.m
//  Slowest Tests
//
//  Created by Michael Johnson on 10/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLFetcher.h"

@interface URLFetcherTimeOutTests : XCTestCase
@property (strong,nonatomic) NSString *responseString;
@property (strong,nonatomic) NSError *error;
@end

@implementation URLFetcherTimeOutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

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

- (void)testFetchDataForURLStringCompletionHandlerWithTimeout {
    
    // We can't connect ot port 81 so this should timeout.
    [self fetchDataForURLStringAndWaitForResponse:@"https://www.google.com:81"];
    
    XCTAssertNil(self.responseString);
    XCTAssertNotNil(self.error);
    XCTAssertEqualObjects(self.error.domain,NSURLErrorDomain);
}

@end
