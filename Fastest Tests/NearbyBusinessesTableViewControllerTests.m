//
//  NearbyBusinessesTableViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "NearbyBusinessesTableViewController.h"
#import "NearbyBusinessesController.h"

@interface NearbyBusinessesTableViewControllerTests : XCTestCase

@end

@implementation NearbyBusinessesTableViewControllerTests

- (void)testNearbyBusinessesTableViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    NearbyBusinessesTableViewController *viewController = [SUT instantiateViewControllerWithIdentifier:@"NearbyBusinessesTableViewController"];
    NearbyBusinessesController *fakeDelegate = OCMPartialMock([NearbyBusinessesController new]);
    viewController.controller = fakeDelegate;
    [viewController view];
    UITableViewCell *cell = [viewController.tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    XCTAssertNotNil(cell.detailTextLabel);
    
    XCTAssertEqualObjects(viewController.navigationItem.title,@"Nearby Businesses");
}

@end
