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

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)test {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    NearbyBusinessesDataSource *fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    SUT.dataSource = fakeDataSource;
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    SUT.tableView = fakeTableView;
    
    [SUT viewDidLoad];
    
    OCMVerify([fakeTableView setDataSource:SUT.dataSource]);
    OCMVerify([fakeDataSource setDelegate:SUT]);
    OCMVerify([fakeDataSource updateLocationAndBusinessesAndNotifyDelegate]);
    
    [SUT nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
    OCMVerify([fakeTableView reloadData]);
}

@end
