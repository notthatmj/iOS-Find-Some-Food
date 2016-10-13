//
//  MainStoryboardTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesTableViewController.h"
#import "OCMock.h"

@interface MyRefreshControl : UIRefreshControl
@property (nonatomic) BOOL theThingWasCalled;
@end

@implementation MyRefreshControl

@end

@interface MainStoryboardTests : XCTestCase

@end

@implementation MainStoryboardTests

- (void)testInitialViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    UIViewController *initialViewController = [SUT instantiateInitialViewController];
    XCTAssert([initialViewController isKindOfClass:[NearbyBusinessesTableViewController class]]);
}

- (void)testInitialViewControllerTableCell {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    NearbyBusinessesTableViewController *initialViewController = [SUT instantiateInitialViewController];
    
    UITableViewCell *cell = [initialViewController.tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    XCTAssertNotNil(cell.detailTextLabel);
}

@end
