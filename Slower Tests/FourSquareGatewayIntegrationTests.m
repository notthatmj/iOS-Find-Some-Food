//
//  FourSquareGatewayTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/8/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquareGateway.h"
#import "URLFetcher.h"
#import "Business.h"

@interface FourSquareGatewayIntegrationTests : XCTestCase<FourSquareGatewayDelegate>
@property (nonatomic,strong) FourSquareGateway *SUT;
@property (nonatomic,strong) XCTestExpectation *expectation;
@end

@implementation FourSquareGatewayIntegrationTests

-(void)setUp {
    [super setUp];
    self.SUT = [FourSquareGateway new];
}

- (void)testGetNearbyBusinessForLatitudeLongitude {
    double latitude = 41.884529;
    double longitude = -87.627813;
    self.expectation = [self expectationWithDescription:@"expectation"];
    self.SUT.delegate = self;
    [self.SUT getNearbyBusinessesForLatitude:latitude longitude:longitude];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    XCTAssertNotNil(self.SUT.businesses);
    XCTAssert([self.SUT.businesses count] > 1);
    for (Business *business in self.SUT.businesses) {
        XCTAssertNotNil(business.name);
    }
}

-(void)testDownloadPhotoDictForVenueID{
    self.SUT = [FourSquareGateway new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [self.SUT downloadPhotoDictForVenueID:@"4b3d120ff964a520458d25e3" completionHandler:^(NSDictionary *photoDict){
        XCTAssertNotNil(photoDict);
        XCTAssertNotEqual([photoDict count],0);
        XCTAssertNotNil([photoDict valueForKey:@"meta"]);
        XCTAssertEqualObjects([NSNumber numberWithInt:200],photoDict[@"meta"][@"code"]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

-(void)testGetFirstPhotoURLForVenueID {
    self.SUT = [FourSquareGateway new];
    NSString *url = [self.SUT getFirstPhotoURLForVenueID:@"4b3d120ff964a520458d25e3"];
    XCTAssertNotNil(url);
    NSString *expectedPrefix = @"https://";
    XCTAssertEqualObjects([url substringToIndex:[expectedPrefix length]], expectedPrefix);
    NSString *expectedSuffix = @".jpg";
    XCTAssertEqualObjects([url substringFromIndex:[url length]-[expectedSuffix length]], expectedSuffix);
    NSString *expectedSizeString = @"100x100";
    XCTAssert([url containsString:expectedSizeString]);
}

-(void)testDownloadFirstPhotoForVenueID {
    self.SUT = [FourSquareGateway new];
    
    UIImage *image = [self.SUT downloadFirstPhotoForVenueID:@"4b3d120ff964a520458d25e3"];
    XCTAssertNotNil(image);
    XCTAssertNotEqual(image.size.height, 0);
}

-(void)fourSquareGatewayDidFinishGettingBusinesses {
    [self.expectation fulfill];
}

-(void)fourSquareGatewayDidFail {

}

@end
