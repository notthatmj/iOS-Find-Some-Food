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
@end

@implementation FourSquareGatewayUnitTests

-(void)setUp {
    [super setUp];
    self.SUT = [FourSquareGateway new];
}

-(void)testGetNearbyBusinessesForLatitudeLongitude {
    // Setup
    self.SUT.clientID = @"parrot";
    self.SUT.clientSecret = @"bar";
    id delegateMock = OCMProtocolMock(@protocol(FourSquareGatewayDelegate));
    self.SUT.delegate = delegateMock;
    
    id fakeURLFetcher = OCMClassMock([URLFetcher class]);
    NSString *expectedURL = @"https://api.foursquare.com/v2/venues/search?client_id=parrot&client_secret=bar&v=20130815&ll=40.70000,-74.00000&query=sushi";
    NSData *fakeResponseData = [NSData new];
    OCMStub([fakeURLFetcher fetchURLData:expectedURL completionHandler:([OCMArg invokeBlockWithArgs:fakeResponseData, nil])]);
    
    id parserMock = OCMClassMock([FourSquareResponseParser class]);
    NSArray *businesses = [self makeBusinesses];
    OCMStub([parserMock parseResponseData:[OCMArg isEqual:fakeResponseData]]).andReturn(businesses);
    
    id fakeGCDGateway = OCMClassMock([GCDGateway class]);
    OCMStub([fakeGCDGateway dispatchToMainQueue:[OCMArg invokeBlock]]);
    const double latitude = 40.7;
    const double longitude = -74;
    
    // Run
    [self.SUT getNearbyBusinessesForLatitude:latitude longitude:longitude ];
    
    // Verify
    XCTAssertEqual(self.SUT.responseData, fakeResponseData);
    XCTAssertEqualObjects(self.SUT.businesses, businesses);
    OCMVerify([fakeGCDGateway dispatchToMainQueue:[OCMArg any]]);
    OCMVerify([delegateMock fourSquareGatewayDidFinishGettingBusinesses]);
}

- (void)testFourSquareGateway {
    XCTAssertNotNil(self.SUT.clientID);
    XCTAssertNotNil(self.SUT.clientSecret);
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
