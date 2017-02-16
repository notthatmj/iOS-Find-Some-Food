
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
#import "NearbyBusinessesTVCDelegate.h"
#import "MapViewController.h"

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
    XCTAssert([initialViewController isKindOfClass:[UINavigationController class]]);
}

- (void)testNearbyBusinessesTableViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    NearbyBusinessesTableViewController *viewController = [SUT instantiateViewControllerWithIdentifier:@"NearbyBusinessesTableViewController"];
    NearbyBusinessesTVCDelegate *fakeDelegate = OCMPartialMock([NearbyBusinessesTVCDelegate new]);
    viewController.delegate = fakeDelegate;
    [viewController view];
    UITableViewCell *cell = [viewController.tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    XCTAssertNotNil(cell.detailTextLabel);
    
    XCTAssertEqualObjects(viewController.navigationItem.title,@"Nearby Businesses");
}

- (void)testMapViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapViewController = [SUT instantiateViewControllerWithIdentifier:@"MapViewController"];
    XCTAssertNotNil(mapViewController);
    XCTAssertNotNil(SUT);
    
}
@end
