//
//  ControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Controller.h"
#import "OCMock.h"
#import "NearbyBusinessesTableViewController.h"
#import "BusinessFinderErrorDomain.h"

@protocol TestDataSourceProtocol <NSObject>

- arbitraryDataSourceMethodName;

@end

@interface ControllerTests : XCTestCase

@end

@implementation ControllerTests

-(void)testStartInitialLoadAndSuccessfulRetrievalOfBusinesses {
    UIRefreshControl *fakeRefreshControl = OCMClassMock([UIRefreshControl class]);
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    NearbyBusinessesTableViewController *fakeTableViewController = OCMClassMock([NearbyBusinessesTableViewController class]);
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    OCMStub([fakeTableViewController tableView]).andReturn(fakeTableView);
    Controller *SUT = [Controller new];
    SUT.dataSource = fakeDataSource;
    SUT.nearbyBusinessesTableViewController = fakeTableViewController;
    SUT.refreshControl = fakeRefreshControl;
    
    [SUT startInitialLoad];
    
    OCMVerify([fakeTableView setDataSource:fakeDataSource]);
    OCMVerify([fakeDataSource setDelegate:fakeTableViewController]);
    OCMVerify([fakeDataSource updateBusinesses]);
    
    [SUT nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
    
    OCMVerify([fakeTableView reloadData]);
    OCMVerify([fakeRefreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0]);
}

- (void)testNearbyBusinessesDataSourceDidFail {
    // Setup
    UIRefreshControl *fakeRefreshControl = OCMClassMock([UIRefreshControl class]);
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    NearbyBusinessesTableViewController *fakeTableViewController = OCMClassMock([NearbyBusinessesTableViewController class]);
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    OCMStub([fakeTableViewController tableView]).andReturn(fakeTableView);
    Controller *SUT = [Controller new];
    SUT.dataSource = fakeDataSource;
    SUT.nearbyBusinessesTableViewController = fakeTableViewController;
    SUT.refreshControl = fakeRefreshControl;
    
    NSString *testErrorMessage = @"foobar";
    NSDictionary *testUserInfo = @{NSLocalizedDescriptionKey : testErrorMessage};
    NSError *testError = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                             code:kBusinessesDataControllerErrorLocation
                                         userInfo:testUserInfo];
    
    // Run
    [SUT nearbyBusinessesDataSourceDidFailWithError:testError];
    
    // Verify
    BOOL (^checkAlertController)(id obj) = ^BOOL(id obj) {
        
        UIAlertController* alert = obj;
        
        if(![alert.title isEqualToString:@"Error"] ||
           ![alert.message isEqualToString:testErrorMessage] ||
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
    OCMVerify([fakeTableViewController presentViewController:[OCMArg checkWithBlock:checkAlertController]
                                                    animated:YES
                                                  completion:nil]);
    OCMVerify([fakeRefreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0]);
}

- (void)testinstallRefreshControlOnTableViewUpdateSelector {
    Controller *SUT = [Controller new];
    UITableView *tableView = [UITableView new];
    id dataSourceMock = OCMProtocolMock(@protocol(UITableViewDataSource));
    tableView.dataSource = dataSourceMock;
    
    [SUT installRefreshControlOnTableView:tableView selector:@selector(arbitraryDataSourceMethodName)];
    
    XCTAssertNotNil(tableView.refreshControl);
    XCTAssertEqual(tableView.refreshControl, SUT.refreshControl);
    NSSet *targets = [SUT.refreshControl allTargets];
    XCTAssertEqual([targets count], 1);
    id target = [targets allObjects][0];
    XCTAssertEqual(target,dataSourceMock);
    id actions = [tableView.refreshControl actionsForTarget:dataSourceMock forControlEvent:UIControlEventValueChanged];
    XCTAssertEqual([actions count], 1);
    XCTAssertEqualObjects(actions[0], @"arbitraryDataSourceMethodName");
}

- (void)testBeginRefreshingEndRefreshing2 {
    Controller *SUT = [Controller new];
    UIRefreshControl *refreshControl = OCMClassMock([UIRefreshControl class]);
    SUT.refreshControl = refreshControl;
    
    [SUT beginRefreshing];
    OCMVerify([refreshControl performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.0]);
    [SUT endRefreshing];
    OCMVerify([refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0]);

}

@end
