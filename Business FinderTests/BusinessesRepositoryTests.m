//
//  BusinessesRepositoryTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesRepository.h"
#import "FourSquareGateway.h"
#import "OCMock.h"
#import "Business.h"

@interface FakeFourSquareGateway : FourSquareGateway
-(void) findBusinessesForLatitude:(double) latitude Longitude:(double) longitude completionHandler:(void (^)())completionHandler;
@end

@implementation FakeFourSquareGateway
-(void)findBusinessesForLatitude:(double)latitude Longitude:(double)longitude completionHandler:(void (^)())completionHandler {
    return;
}
@end

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

- (void)testBusinessesRepository2 {
    BusinessesRepository *SUT = [BusinessesRepository new];
//    FourSquareGateway *fourSquareGateway = OCMClassMock([FourSquareGateway class]);
    FakeFourSquareGateway *fourSquareGateway = [FakeFourSquareGateway new];
    SUT.fourSquareGateway = fourSquareGateway;
    SUT.latitude = 41.884529;
    SUT.longitude = -87.627813;

//    [FakeFourSquareGateway ];
    
//    [SUT.fourSquareGateway getNearbyBusinessesForLatitude:ChicagoLatitude
//                                                Longitude:ChicagoLongitude
//                                        completionHandler:^void(NSArray<Business *>businesses) {
//                                            
//                                        }];
    
    XCTAssertEqual(SUT.businesses.count,0);
    __block Boolean blockWasRun = NO;
    [SUT updateBusinessesAndCallBlock:^{blockWasRun = YES;}];
    XCTAssertTrue(blockWasRun);
    XCTAssertEqual(SUT.businesses.count,2);
    XCTAssertEqualObjects([SUT.businesses[0] name],@"Trader Joe's");
    XCTAssertEqualObjects([SUT.businesses[1] name],@"Aldi");
}

- (void)testBusinessesRepository3 {
    BusinessesRepository *SUT = [BusinessesRepository new];
    id fourSquareGateway = OCMClassMock([FourSquareGateway class]);
    SUT.fourSquareGateway = fourSquareGateway;
    
    [SUT updateBusinessesAndCallBlock:^{}];
    
//    OCMVerify([fourSquareGateway getNearbyBusinessesForLatitude:[OCMArg any] longitude:[OCMArg any] completionHandler:[OCMArg any]]);
    OCMVerify([[fourSquareGateway ignoringNonObjectArgs] getNearbyBusinessesForLatitude:0
                                                                              longitude:0
                                                                      completionHandler:[OCMArg any]]);
    
}

@end
