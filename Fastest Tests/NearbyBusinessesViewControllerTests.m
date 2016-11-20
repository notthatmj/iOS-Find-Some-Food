//
//  NearbyBusinessesViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesTableViewController.h"
#import "NearbyBusinessesDataSource.h"
#import "Business.h"
#import "OCMock.h"
#import "LocationGateway.h"
#import "Controller.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoad {
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    Controller *fakeController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc]
                                                initWithDataSource:fakeDataSource
                                                controller:fakeController];
    [SUT viewDidLoad];
    
    OCMVerify([fakeController startInitialLoad]);
}

- (void)testNearbyBusinessesDataSourceDidFail {
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    Controller *fakeController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc]
                                                initWithDataSource:fakeDataSource
                                                controller:fakeController];
    NSError *testError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:nil];
    [SUT nearbyBusinessesDataSourceDidFailWithError:testError];
    OCMVerify([fakeController nearbyBusinessesDataSourceDidFailWithError:testError]);
}

-(void)testViewDidLoadInitializesRefreshController {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    
    [SUT viewDidLoad];
    [SUT waitForInitialLoadToComplete];
    
    XCTAssertNotNil(SUT.controller);
}

-(void)testViewDidLoadInstallsRefreshControl{
    Controller *mockController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc] initWithDataSource:nil controller:mockController];
    [SUT viewDidLoad];
    [SUT waitForInitialLoadToComplete];
    
    OCMVerify([mockController installRefreshControlOnTableView:SUT.tableView
                                                             selector:@selector(updateBusinesses)]);
}

@end
