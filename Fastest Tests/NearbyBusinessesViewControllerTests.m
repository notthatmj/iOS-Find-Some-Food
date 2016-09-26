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
#import "RefreshController.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoadAndSuccessfulRetrievalOfBusinesses {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    SUT.dataSource = fakeDataSource;
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.tableView = fakeTableView;
    RefreshController *mockRefreshController = OCMClassMock([RefreshController class]);
    SUT.refreshController = mockRefreshController;
    
    [SUT viewDidLoad];
    
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
    OCMVerify([fakeDataSource setDelegate:SUT]);
    OCMVerify([fakeDataSource updateBusinesses]);
    
    [SUT nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];

    OCMVerify([fakeTableView reloadData]);
    OCMVerify([mockRefreshController endRefreshing]);
}

- (void)testNearbyBusinessesDataSourceDidFail {
    // Setup
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    SUT = OCMPartialMock(SUT);
    OCMStub([SUT presentViewController:[OCMArg any] animated:YES completion:nil]);
//    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    RefreshController *mockRefreshController = OCMClassMock([RefreshController class]);
    SUT.refreshController = mockRefreshController;

    // Run
    [SUT nearbyBusinessesDataSourceDidFail];
    
    // Verify
    BOOL (^checkAlertController)(id obj) = ^BOOL(id obj) {
        
        UIAlertController* alert = obj;
        
        if(![alert.title isEqualToString:@"Error"] ||
           ![alert.message isEqualToString:@"Businesses couldn't be retrieved"] ||
           alert.preferredStyle != UIAlertControllerStyleAlert ||
           [alert.actions count] != 1) {
            return false;
        }

        UIAlertAction *action = alert.actions[0];
        if (![action.title isEqualToString:@"OK"] ||
            action.style != UIAlertActionStyleDefault) {
            return false;
        }
        return true;
    };
    OCMVerify([SUT presentViewController:[OCMArg checkWithBlock:checkAlertController]
                                animated:YES
                              completion:nil]);
    OCMVerify([mockRefreshController endRefreshing]);
}

-(void)testInit {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    
    XCTAssertNil(SUT.refreshController);
}

-(void)testViewDidLoadInitializesRefreshController {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    
    [SUT viewDidLoad];
    
    XCTAssertNotNil(SUT.refreshController);
}

-(void)testViewDidLoadKeepsNonNilRefreshController {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    RefreshController *originalRefreshController = [RefreshController new];
    SUT.refreshController = originalRefreshController;
    
    [SUT viewDidLoad];
    
    XCTAssertEqual(originalRefreshController, SUT.refreshController);
}

-(void)testViewDidLoadInstallsRefreshControl{
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    RefreshController *mockRefreshController = OCMClassMock([RefreshController class]);
    SUT.refreshController = mockRefreshController;
    
    [SUT viewDidLoad];
    
    OCMVerify([mockRefreshController installRefreshControlOnTableView:SUT.tableView
                                                             selector:@selector(updateBusinesses)]);
}

@end
