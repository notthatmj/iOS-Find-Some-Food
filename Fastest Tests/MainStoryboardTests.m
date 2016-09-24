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

//- (void)testInitialViewController2 {
//    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    XCTAssertNotNil(SUT);
//    NearbyBusinessesTableViewController *initialViewController = [SUT instantiateInitialViewController];
//    
//    [initialViewController viewDidLoad];
//    
//    id refreshControlMock = OCMPartialMock([UIRefreshControl new]);
//    initialViewController.refreshControl = refreshControlMock;
//    initialViewController.refreshControl = [UIRefreshControl new];
//    [initialViewController nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
//    
////    id refreshControlMock = [MyRefreshControl new];
////    initialViewController.refreshControl = refreshControlMock;
////    [initialViewController nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
////    OCMVerify([refreshControlMock endRefreshing]);
//}

@end
