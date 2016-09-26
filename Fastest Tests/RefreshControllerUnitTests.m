//
//  RefreshControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RefreshController.h"
#import "OCMock.h"

@protocol TestDataSourceProtocol <NSObject>

- arbitraryDataSourceMethodName;

@end

@interface RefreshControllerTests : XCTestCase

@end

@implementation RefreshControllerTests

- (void)testinstallRefreshControlOnTableViewUpdateSelector {
    RefreshController *SUT = [RefreshController new];
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

- (void)testBeginRefreshingEndRefreshing {
    RefreshController *SUT = [RefreshController new];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    SUT.refreshControl = refreshControl;
    
    [SUT beginRefreshing];
    XCTAssert(refreshControl.isRefreshing);
    [SUT endRefreshing];
    XCTAssert(!refreshControl.isRefreshing);
}


@end
