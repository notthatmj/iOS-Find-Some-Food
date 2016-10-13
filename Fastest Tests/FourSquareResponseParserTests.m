//
//  FourSquareResponseParserTests.m
//  Business Finder
//
//  Created by Michael Johnson on 10/6/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquareResponseParser.h"
#import "Business.h"

@interface FourSquareResponseParserTests : XCTestCase

@end

@implementation FourSquareResponseParserTests

- (void)setUp {
    [super setUp];
}

- (void)testFourSquareResponseParser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Sample FourSquare Response" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray<Business *> *businesses = [FourSquareResponseParser parseResponseData:data];
    Business *firstBusiness = businesses[0];
    XCTAssertEqualObjects(firstBusiness.name,@"Hot Woks Cool Sushi");
    XCTAssertEqual(firstBusiness.distance, 25);
}


@end
