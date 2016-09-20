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
//#import "FourSquareGatewayTests.m"

@interface TestDelegate : NSObject<BusinessesDataControllerDelegate>

@end
@implementation TestDelegate

-(void)businessesDataControllerDidUpdateBusinesses {
    
}

@end

@interface IntegrationTests : XCTestCase<BusinessesDataControllerDelegate>
@property (strong, nonatomic) XCTestExpectation *expectation;
@end

@implementation IntegrationTests

//- (void)testBusinessesDataControllerBlockAPIIntegration {
//    // Setup
//    BusinessesDataController *SUT = [BusinessesDataController new];
//    XCTAssertEqual(SUT.businesses.count,0);
//    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation" ];
//
//    // Run
//    [SUT updateLocationAndBusinessesAndCallBlock:^{
//        [expectation fulfill];
//    }];
//    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {}];
//    
//    // Verify
//    XCTAssertNotNil(SUT.businesses);
//    XCTAssert([SUT.businesses count] > 1);
//    for (Business *business in SUT.businesses) {
//        XCTAssertNotNil(business.name);
//    }    
//}

- (void)testBusinessesDataControllerDelegateAPIIntegration {
    // Setup
    BusinessesDataController *SUT = [BusinessesDataController new];
    SUT.delegate = self;
    XCTAssertEqual(SUT.businesses.count,0);
    self.expectation = [self expectationWithDescription:@"expectation" ];
    
    // Run
    [SUT updateLocationAndBusinessesAndNotifyDelegate];
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

@end
