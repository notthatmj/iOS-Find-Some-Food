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
    
    NSArray<Business *> *businesses = [FourSquareResponseParser parseSearchResponseData:data];
    Business *firstBusiness = businesses[0];
    float expectedDistance = 0.0155342799;
    double expectedLatitude = 41.95282358664626;
    double expectedLongitude = -87.7277206319607;
    XCTAssertEqualObjects(firstBusiness.name,@"Hot Woks Cool Sushi");
    XCTAssertEqual(firstBusiness.distance, expectedDistance);
    XCTAssertEqualObjects(firstBusiness.fourSquareID,@"4b3d120ff964a520458d25e3");
    XCTAssertEqual(firstBusiness.latitude, expectedLatitude);
    XCTAssertEqual(firstBusiness.longitude, expectedLongitude);
}


@end
