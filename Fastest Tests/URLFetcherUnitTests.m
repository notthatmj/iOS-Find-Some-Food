//
//  URLFetcherUnitTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/22/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLFetcher.h"

@interface URLFetcherUnitTests : XCTestCase

@end

@implementation URLFetcherUnitTests

- (void)testURLFetcher {
//    URLFetcher *SUT = [URL]
    [URLFetcher fetchDataForURLString:@"" completionHandler:^void (NSData *data, NSError *error){}];
}

@end
