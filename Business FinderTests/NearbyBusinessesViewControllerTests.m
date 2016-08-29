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
@property (nonatomic, strong) NearbyBusinessesTableViewController *SUT;
@property (nonatomic, strong) NSArray<Business *> *businesses;
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
    self.SUT = [NearbyBusinessesTableViewController new];
    BusinessesRepository *fakeBusinessesRepository = OCMClassMock([BusinessesRepository class]);
    OCMStub([fakeBusinessesRepository businesses]).andReturn(self.businesses);
    OCMStub([fakeBusinessesRepository updateBusinessesAndCallBlock:[OCMArg invokeBlock]]);
    self.SUT.dataSource.businessesRepository = fakeBusinessesRepository;
}

-(void)testViewDidLoad {
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    self.SUT.view = fakeTableView;
    XCTAssertNotNil(self.SUT);
    [self.SUT viewDidLoad];
    XCTAssertNotNil(self.SUT.dataSource.businessesRepository);
    OCMVerify([fakeTableView setDataSource:self.SUT.dataSource]);
    OCMVerify([self.SUT.dataSource.businessesRepository updateBusinessesAndCallBlock:[OCMArg any]]);
    OCMVerify([fakeTableView reloadData]);
}
@end
