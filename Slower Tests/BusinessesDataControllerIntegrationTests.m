//
//  ModelIntegrationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 10/26/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Model.h"
#import "OCMock.h"

@interface ModelTestObserver : NSObject <ModelObserving>
@property (strong, nonatomic) XCTestExpectation *expectation;
@property (nonatomic) BOOL businessesWereUpdatedSuccessfully;
@end
@implementation ModelTestObserver;
-(void)modelDidUpdateBusinesses {
    self.businessesWereUpdatedSuccessfully = YES;
    [self.expectation fulfill];
}
-(void)modelDidFailWithError:(NSError *)error {
    self.businessesWereUpdatedSuccessfully = NO;
    [self.expectation fulfill];
}
@end

@interface ModelIntegrationTests : XCTestCase

@end

@implementation ModelIntegrationTests

-(void)testUpdateLocationAndBusinesses {
    Model *SUT = [Model new];
    ModelTestObserver *testDelegate = [ModelTestObserver new];
    testDelegate.expectation = [self expectationWithDescription:@"expectation"];
    SUT.observer = testDelegate;
    
    [SUT updateLocationAndBusinesses];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
    XCTAssertTrue(testDelegate.businessesWereUpdatedSuccessfully);
}
@end
