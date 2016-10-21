//
//  FourSquareGatewayUnitTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/13/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquareGateway.h"
#import "Business.h"
#import "OCMock.h"
#import "URLFetcher.h"
#import "FourSquareResponseParser.h"
#import "GCDGateway.h"

@interface FourSquareGatewayUnitTests : XCTestCase
@property (nonatomic,strong) FourSquareGateway *SUT;
@property (nonatomic,strong) NSArray<Business *>* businesses;
@end

@implementation FourSquareGatewayUnitTests

-(void)testGetNearbyBusinessesForLatitudeLongitudeSuccess {
    id fakeError = [NSNull null];
    id delegateMock = OCMProtocolMock(@protocol(FourSquareGatewayDelegate));
    
    [self setupAndRunTestWith:delegateMock error:fakeError];
    
    XCTAssertEqualObjects(self.SUT.businesses, self.businesses);
    OCMVerify([delegateMock fourSquareGatewayDidFinishGettingBusinesses]);
}

-(void)testGetNearbyBusinessesForLatitudeLongitudeWithError {
    id fakeError = [NSError errorWithDomain:@"fakeDomain" code:0 userInfo:nil];
    id delegateMock = OCMProtocolMock(@protocol(FourSquareGatewayDelegate));
    
    [self setupAndRunTestWith:delegateMock error:fakeError];

    OCMVerify([delegateMock fourSquareGatewayDidFail]);
    XCTAssertNil(self.SUT.businesses);
}

- (void)testFourSquareGateway {
    self.SUT = [FourSquareGateway new];
    XCTAssertNotNil(self.SUT.clientID);
    XCTAssertNotNil(self.SUT.clientSecret);
}

-(void)testPhotosURLForVenueID {
    self.SUT = [FourSquareGateway new];
    self.SUT.clientID = @"parrot";
    self.SUT.clientSecret = @"bar";
    NSString *url1 = [self.SUT photosURLForVenueID:@"foobar"];
    XCTAssertEqualObjects(url1, @"https://api.foursquare.com/v2/venues/foobar/photos?client_id=parrot&client_secret=bar&v=20130815");
    NSString *url2 = [self.SUT photosURLForVenueID:@"spam"];
    XCTAssertEqualObjects(url2, @"https://api.foursquare.com/v2/venues/spam/photos?client_id=parrot&client_secret=bar&v=20130815");
}

-(void)setupAndRunTestWith:(id<FourSquareGatewayDelegate>)delegate error:(id) error {
    // Setup
    self.SUT = [FourSquareGateway new];
    self.SUT.clientID = @"parrot";
    self.SUT.clientSecret = @"bar";
    self.SUT.delegate = delegate;
    
    NSData *fakeResponseData = [NSData new];
    id fakeURLFetcher = OCMClassMock([URLFetcher class]);
    NSString *expectedURL = @"https://api.foursquare.com/v2/venues/search?client_id=parrot&client_secret=bar&v=20130815&ll=40.70000,-74.00000&query=sushi";
    OCMStub([fakeURLFetcher fetchDataForURLString:expectedURL
                                     completionHandler:([OCMArg invokeBlockWithArgs:fakeResponseData,
                                                         error, nil])]);
    self.businesses = [self makeBusinesses];
    id parserMock = OCMClassMock([FourSquareResponseParser class]);
    OCMStub([parserMock parseResponseData:[OCMArg isEqual:fakeResponseData]]).andReturn(self.businesses);
    id fakeGCDGateway = OCMClassMock([GCDGateway class]);
    OCMStub([fakeGCDGateway dispatchToMainQueue:[OCMArg invokeBlock]]);
    
    const double latitude = 40.7;
    const double longitude = -74;
    // Run
    [self.SUT getNearbyBusinessesForLatitude:latitude longitude:longitude ];
    
    // Verify
    OCMVerify([fakeGCDGateway dispatchToMainQueue:[OCMArg any]]);
    
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
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
}

-(void)testDownloadPhotoListForVenueID{
    self.SUT = [FourSquareGateway new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [self.SUT downloadPhotoListForVenueID:@"4b3d120ff964a520458d25e3" completionHandler:^(NSArray *photoList){
        XCTAssertNotNil(photoList);
        XCTAssertNotEqual([photoList count],0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
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
}


- (NSMutableArray *) makeBusinesses {
    NSMutableArray *businesses = [NSMutableArray new];
    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
    for (NSString *businessName in businessNames) {
        Business *business = [Business new];
        business.name = businessName;
        [businesses addObject:business];
    }
    return businesses;
}
@end
