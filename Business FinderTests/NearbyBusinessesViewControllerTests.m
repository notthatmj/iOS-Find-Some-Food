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
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *testStoryboard = [UIStoryboard storyboardWithName:@"NearbyBusinessControllerTestsStoryboard" bundle:testBundle];
    self.SUT = [testStoryboard instantiateInitialViewController];
    Business *business1 = [[Business alloc] initWithName:@"Larry's Restaurant" distance:1.0];
    Business *business2 = [[Business alloc] initWithName:@"Moe's Restaurant" distance:2.0];
    Business *business3 = [[Business alloc] initWithName:@"Curly's Restaurant" distance:3.0];
    self.businesses = @[business1,business2,business3];
    id<BusinessesRepository> fakeBusinessesRepository = OCMProtocolMock(@protocol(BusinessesRepository));
    OCMStub([fakeBusinessesRepository businesses]).andReturn(self.businesses);
    self.SUT.dataSource.businessesRepository = fakeBusinessesRepository;
    [self setUpFakeBusinessesRepositoryWithBusinesses:self.businesses];
    // This line is needed to load the view.
    [self.SUT view];
}

- (void)setUpFakeBusinessesRepositoryWithBusinesses: (NSArray<Business *> *) businesses{
    id<BusinessesRepository> fakeBusinessesRepository = OCMProtocolMock(@protocol(BusinessesRepository));
    OCMStub([fakeBusinessesRepository businesses]).andReturn(businesses);
    self.SUT.dataSource.businessesRepository = fakeBusinessesRepository;
}


- (void)testNearbyBusinessesViewController {
    XCTAssertNotNil(self.SUT);
}

- (void)testNumberOfSectionsInTableView {
    UITableView *dummyTableView = [UITableView new];
    NSInteger numberOfSections = [self.SUT numberOfSectionsInTableView:dummyTableView];
    XCTAssertEqual(numberOfSections, 1);
}

- (void)testTableViewCellForRowAtIndexPath {
    for(int i=0;i<self.businesses.count;i++){
        UITableViewCell *cell = [self.SUT tableView:self.SUT.tableView
                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        XCTAssertEqualObjects(cell.textLabel.text, self.businesses[i].name);
    }
}

-(void)testTableViewNumberOfRowsInSection {
    XCTAssertEqual([self.SUT tableView:self.SUT.tableView numberOfRowsInSection:0],3);
}

-(void)testViewDidLoadCallsUpdateBusinesses {
    XCTAssertNotNil(self.SUT.dataSource.businessesRepository);
    OCMVerify([self.SUT.dataSource.businessesRepository updateBusinesses]);
}
@end
