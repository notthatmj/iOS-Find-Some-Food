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
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:40.7589]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:-73.9851]);
    OCMStub([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg invokeBlock]]);
    id fakeBusinessesRepository = OCMClassMock([BusinessesRepository class]);
    OCMStub([fakeBusinessesRepository updateBusinessesAndCallBlock:[OCMArg invokeBlock]]);
    SUT.dataSource.businessesRepository = fakeBusinessesRepository;
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.tableView = fakeTableView;
    
//    SUT.dataSource.businessesRepository.locationGateway = fakeLocationGateway;
    OCMStub([SUT.dataSource.businessesRepository locationGateway]).andReturn(fakeLocationGateway);
    [SUT viewDidLoad];
    
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
    XCTAssertEqual(SUT.dataSource.businessesRepository.locationGateway, fakeLocationGateway);
    OCMVerify([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg any]]);
    OCMVerify([fakeBusinessesRepository setLatitude:40.7589]);
    OCMVerify([fakeBusinessesRepository setLongitude:-73.9851]);
    OCMVerify([fakeTableView reloadData]);
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLongitude:0]);

}
@end
