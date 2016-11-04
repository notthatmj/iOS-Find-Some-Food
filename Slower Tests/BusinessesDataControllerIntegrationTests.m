//
//  BusinessesDataControllerIntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 10/26/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessesDataController.h"
#import "OCMock.h"

@interface BusinessesDataControllerTestDelegate : NSObject <BusinessesDataControllerDelegate>
@property (strong, nonatomic) XCTestExpectation *expectation;
@property (nonatomic) BOOL businessesWereUpdatedSuccessfully;
@end
@implementation BusinessesDataControllerTestDelegate;
-(void)businessesDataControllerDidUpdateBusinesses {
    self.businessesWereUpdatedSuccessfully = YES;
    [self.expectation fulfill];
}
-(void)businessesDataControllerDidFailWithError:(NSError *)error {
    self.businessesWereUpdatedSuccessfully = NO;
    [self.expectation fulfill];
}
@end

@interface BusinessesDataControllerIntegrationTests : XCTestCase

@end

@implementation BusinessesDataControllerIntegrationTests

-(void)testUpdateLocationAndBusinesses {
    BusinessesDataController *SUT = [BusinessesDataController new];
    BusinessesDataControllerTestDelegate *testDelegate = [BusinessesDataControllerTestDelegate new];
    testDelegate.expectation = [self expectationWithDescription:@"expectation"];
    SUT.delegate = testDelegate;
    
    [SUT updateLocationAndBusinesses];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
    XCTAssertTrue(testDelegate.businessesWereUpdatedSuccessfully);
}
@end
