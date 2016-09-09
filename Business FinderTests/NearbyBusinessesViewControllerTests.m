//
//  NearbyBusinessesViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessFinder.h"
#import "NearbyBusinessesTableViewController.h"
#import "NearbyBusinessesDataSource.h"
#import "Business.h"
#import "OCMock.h"
#import "LocationGateway.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoadInitializesLocationGateway {
    // Setup
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    XCTAssertNotNil(SUT);
    
    // Run
    [SUT viewDidLoad];
    
    // Verify
    XCTAssertNotNil(SUT.dataSource.businessesRepository.locationGateway);
//    XCTAssertNotNil(SUT.dataSource.businessesRepository.locationGateway);
}

-(void)testViewDidLoad {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    OCMStub([fakeDataSource updateLocationAndBusinessesAndCallBlock:[OCMArg invokeBlock]]);
    SUT.dataSource = fakeDataSource;
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.tableView = fakeTableView;
    
    [SUT viewDidLoad];
    
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
    OCMVerify([fakeDataSource updateLocationAndBusinessesAndCallBlock:[OCMArg any]]);
    OCMVerify([SUT.tableView reloadData]);
}

@end
