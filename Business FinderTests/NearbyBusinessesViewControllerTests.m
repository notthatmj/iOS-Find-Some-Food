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

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoad {
    // Setup
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    id fakeBusinessesRepository = OCMClassMock([BusinessesRepository class]);
    OCMStub([fakeBusinessesRepository updateBusinessesAndCallBlock:[OCMArg invokeBlock]]);
    SUT.dataSource.businessesRepository = fakeBusinessesRepository;
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.view = fakeTableView;
    XCTAssertNotNil(SUT);

    // Run
    [SUT viewDidLoad];
    
    // Verify
    XCTAssertNotNil(SUT.dataSource.businessesRepository);
    XCTAssertNotNil(SUT.locationGateway);
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLatitude:0]);
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLongitude:0]);
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
    OCMVerify([SUT.dataSource.businessesRepository updateBusinessesAndCallBlock:[OCMArg any]]);
    OCMVerify([fakeTableView reloadData]);
}
@end
