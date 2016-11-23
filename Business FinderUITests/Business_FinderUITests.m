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
    float loadTimeout = 20.0;
    [self waitForExpectationsWithTimeout:loadTimeout handler:nil];

    // Test that there's one "Business Name" label for every cell.
    XCUIElementQuery *businessNameQuery = [[tablesQuery staticTexts] matchingIdentifier:@"Business Name"];
    NSUInteger businessNameCount = [businessNameQuery count];
    NSUInteger cellCount = [cellsQuery count];
    XCTAssertEqual(businessNameCount, cellCount);
    
    // Test that there's one "Distance" label for every cell.
    XCUIElementQuery *distanceQuery = [[tablesQuery staticTexts] matchingIdentifier:@"Distance"];
    NSUInteger distanceCount = [distanceQuery count];
    XCTAssertEqual(cellCount, distanceCount);
    
    // Test that at least some of the photos loaded correctly.
    XCUIElementQuery *imagesQuery = [tablesQuery.images matchingIdentifier:@"photo"];
    NSUInteger imagesCount = [imagesQuery count];
    XCTAssertLessThanOrEqual(1, imagesCount);
    XCTAssertLessThanOrEqual(imagesCount, cellCount);
}

@end
