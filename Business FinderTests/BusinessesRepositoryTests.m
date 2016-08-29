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

@interface BusinessesRepositoryTests : XCTestCase

@end

@implementation BusinessesRepositoryTests

- (void)testBusinessesRepository {
    BusinessesRepository *SUT = [BusinessesRepository new];
    NSMutableArray *businesses = [NSMutableArray new];
    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
    for (NSString *businessName in businessNames) {
        Business *business = [Business new];
        business.name = businessName;
        [businesses addObject:business];
    }

    id fourSquareGateway = OCMClassMock([FourSquareGateway class]);
    OCMStub([fourSquareGateway businesses]).andReturn(businesses);
    OCMStub([[fourSquareGateway ignoringNonObjectArgs] getNearbyBusinessesForLatitude:0 longitude:0 completionHandler:[OCMArg invokeBlock]]);
    SUT.fourSquareGateway = fourSquareGateway;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];

    [SUT updateBusinessesAndCallBlock:^{
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {}];
    OCMVerify([[fourSquareGateway ignoringNonObjectArgs] getNearbyBusinessesForLatitude:0
                                                                              longitude:0
                                                                      completionHandler:[OCMArg any]]);
    XCTAssertEqual([SUT.businesses count],2);
    XCTAssertEqualObjects(SUT.businesses[0].name, businessNames[0]);
    XCTAssertEqualObjects(SUT.businesses[1].name, businessNames[1]);
}

@end
