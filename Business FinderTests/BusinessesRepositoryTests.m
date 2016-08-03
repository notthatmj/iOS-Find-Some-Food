//
//  BusinessesRepositoryTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesRepository.h"

@interface BusinessesRepositoryTests : XCTestCase

@end

@implementation BusinessesRepositoryTests

- (void)setUp {
    [super setUp];
}

- (void)testBusinessesRepository {
    BusinessesRepository *SUT = [BusinessesRepository new];
    
    XCTAssertEqual(SUT.businesses.count,0);
    __block Boolean blockWasRun = NO;
    [SUT updateBusinessesAndCallBlock:^{blockWasRun = YES;}];
    XCTAssertTrue(blockWasRun);
    XCTAssertEqual(SUT.businesses.count,2);
    XCTAssertEqualObjects([SUT.businesses[0] name],@"Trader Joe's");
    XCTAssertEqualObjects([SUT.businesses[1] name],@"Aldi");
}

@end
