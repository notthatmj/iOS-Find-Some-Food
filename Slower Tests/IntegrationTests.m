//
//  IntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/29/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesDataController.h"
#import "Business.h"

@interface IntegrationTests : XCTestCase<BusinessesDataControllerDelegate>
@property (strong, nonatomic) XCTestExpectation *expectation;
@end

@implementation IntegrationTests

- (void)testBusinessesDataControllerDelegateAPIIntegration {
    // Setup
    BusinessesDataController *SUT = [BusinessesDataController new];
    SUT.delegate = self;
    XCTAssertEqual(SUT.businesses.count,0);
    self.expectation = [self expectationWithDescription:@"expectation" ];
    
    // Run
    [SUT updateLocationAndBusinesses];
    [self waitForExpectationsWithTimeout:25.0 handler:^(NSError * _Nullable error) {}];
    
    // Verify
    XCTAssertNotNil(SUT.businesses);
    XCTAssert([SUT.businesses count] > 1);
    for (Business *business in SUT.businesses) {
        XCTAssertNotNil(business.name);
    }
}
-(void)businessesDataControllerDidUpdateBusinesses {
    [self.expectation fulfill];
}
-(void)businessesDataControllerDidFailWithError:(NSError *)error {
    
}
@end
