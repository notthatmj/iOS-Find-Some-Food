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
#import "BusinessFinderErrorDomain.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoadAndSuccessfulRetrievalOfBusinesses {
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    Controller *mockController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc]
                                                initWithDataSource:fakeDataSource
                                                controller:mockController];
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.tableView = fakeTableView;

    [SUT viewDidLoad];
    
    OCMVerify([fakeTableView setDataSource:fakeDataSource]);
    OCMVerify([fakeDataSource setDelegate:SUT]);
    OCMVerify([fakeDataSource updateBusinesses]);
    
    [SUT nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];

    OCMVerify([fakeTableView reloadData]);
    OCMVerify([mockController endRefreshing]);
}

- (void)testNearbyBusinessesDataSourceDidFail {
    // Setup
    Controller *mockController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController new]
                                                initWithDataSource:nil controller:mockController];
    SUT = OCMPartialMock(SUT);
    OCMStub([SUT presentViewController:[OCMArg any] animated:YES completion:nil]);
    
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
    OCMVerify([SUT presentViewController:[OCMArg checkWithBlock:checkAlertController]
                                animated:YES
                              completion:nil]);
    OCMVerify([mockController endRefreshing]);
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
