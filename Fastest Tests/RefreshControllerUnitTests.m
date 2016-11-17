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

@protocol TestDataSourceProtocol <NSObject>

- arbitraryDataSourceMethodName;

@end

@interface ControllerTests : XCTestCase

@end

@implementation ControllerTests

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
