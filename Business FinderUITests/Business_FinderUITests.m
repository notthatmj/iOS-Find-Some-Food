//
//  Business_FinderUITests.m
//  Business FinderUITests
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Business_FinderUITests : XCTestCase

@end

@implementation Business_FinderUITests

- (void)testBasicUI {
    self.continueAfterFailure = NO;
    // Set up a handler to tap "Allow" in case a system dialog requesting location access
    // is triggered.
    [self addUIInterruptionMonitorWithDescription:@"Location Dialog"
                                          handler:^BOOL(XCUIElement * _Nonnull interruptingElement) {
                                              [interruptingElement.buttons[@"Allow"] tap];
                                              return YES;
                                          }];
    
    // Launch app
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    [app tap];
    
    // Wait for cells to load
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElementQuery *cellsQuery = [tablesQuery descendantsMatchingType:XCUIElementTypeCell];
    NSPredicate *cellsDidLoad = [NSPredicate predicateWithFormat:@"count >= 1"];
    [self expectationForPredicate:cellsDidLoad evaluatedWithObject:cellsQuery handler:nil];
    float loadTimeout = 10.0;
    [self waitForExpectationsWithTimeout:loadTimeout handler:nil];
}

@end
