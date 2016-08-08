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
    self.SUT.dataSource.businessesRepository = fakeBusinessesRepository;
    [self.SUT view];
}

- (void)testNearbyBusinessesViewController {
    XCTAssertNotNil(self.SUT);
}

-(void)testViewDidLoad {
    XCTAssertNotNil(self.SUT);
    XCTAssertNotNil(self.SUT.dataSource.businessesRepository);
    OCMVerify([self.SUT.dataSource.businessesRepository updateBusinesses]);
    XCTAssertEqual(self.SUT.tableView.dataSource, self.SUT.dataSource);
}
@end
