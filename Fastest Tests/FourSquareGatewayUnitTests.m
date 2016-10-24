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

-(void)testDownloadFirstPhotoForVenueID {
    self.SUT = [FourSquareGateway new];

    UIImage *image = [self.SUT downloadFirstPhotoForVenueID:@"4b3d120ff964a520458d25e3"];
    XCTAssertNotNil(image);
    XCTAssertNotEqual(image.size.height, 0);
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
