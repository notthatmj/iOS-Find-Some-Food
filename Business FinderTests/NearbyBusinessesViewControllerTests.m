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
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLatitude:0]);
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLongitude:0]);
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
//    OCMVerify([SUT.dataSource.businessesRepository updateBusinessesAndCallBlock:[OCMArg any]]);
//    OCMVerify([fakeTableView reloadData]);
}

-(void)testViewDidLoadInitializesLocationGateway {
    // Setup
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    XCTAssertNotNil(SUT);
    
    // Run
    [SUT viewDidLoad];
    
    // Verify
    XCTAssertNotNil(SUT.locationGateway);
}

-(void)testViewDidLoadUsesPresetLocationGateway {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    SUT.locationGateway = fakeLocationGateway;
    
    [SUT viewDidLoad];
    
    XCTAssertEqual(SUT.locationGateway, fakeLocationGateway);
    
}
-(void)testViewDidLoad2 {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    LocationGateway *fakeLocationGateway = OCMClassMock([LocationGateway class]);
    OCMStub([fakeLocationGateway latitude]).andReturn([NSNumber numberWithDouble:40.7589]);
    OCMStub([fakeLocationGateway longitude]).andReturn([NSNumber numberWithDouble:-73.9851]);
    OCMStub([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg invokeBlock]]);
    id fakeBusinessesRepository = OCMClassMock([BusinessesRepository class]);
    SUT.dataSource.businessesRepository = fakeBusinessesRepository;

    SUT.locationGateway = fakeLocationGateway;
    [SUT viewDidLoad];
    
    XCTAssertEqual(SUT.locationGateway, fakeLocationGateway);
    OCMVerify([fakeLocationGateway fetchLocationAndCallBlock:[OCMArg any]]);
    OCMVerify([fakeBusinessesRepository setLatitude:40.7589]);
    OCMVerify([fakeBusinessesRepository setLongitude:-73.9851]);
    
    OCMVerify([[fakeBusinessesRepository ignoringNonObjectArgs] setLongitude:0]);

}
@end
