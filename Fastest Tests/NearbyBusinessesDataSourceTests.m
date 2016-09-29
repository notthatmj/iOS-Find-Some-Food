//
//  NearbyBusinessesDataSourceTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/4/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesDataSource.h"
#import "Business.h"
#import "BusinessesDataController.h"
#import "OCMock.h"

@interface DummyCellClass : UITableViewCell
@end
@implementation DummyCellClass
@end

@interface NearbyBusinessesDataSourceTests : XCTestCase
@property (nonnull,strong) NearbyBusinessesDataSource *SUT;
@property (nonatomic, strong) NSArray<Business *> *businesses;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation NearbyBusinessesDataSourceTests

- (void)setUp {
    [super setUp];
    self.SUT = [NearbyBusinessesDataSource new];
    Business *business1 = [[Business alloc] initWithName:@"Larry's Restaurant" distance:1.0];
    Business *business2 = [[Business alloc] initWithName:@"Moe's Restaurant" distance:2.0];
    Business *business3 = [[Business alloc] initWithName:@"Curly's Restaurant" distance:3.0];
    self.businesses = @[business1,business2,business3];
    BusinessesDataController *fakeBusinessesDataController = OCMClassMock([BusinessesDataController class]);
    OCMStub([fakeBusinessesDataController businesses]).andReturn(self.businesses);
    self.SUT.businessesDataController = fakeBusinessesDataController;
    
    self.tableView = [UITableView new];
    [self.tableView registerClass:[DummyCellClass class] forCellReuseIdentifier:@"PrototypeCell"];
    self.tableView.dataSource = self.SUT;
}

- (void)testNumberOfSectionsInTableView {
    NSInteger result = [self.SUT numberOfSectionsInTableView:self.tableView];
    
    XCTAssertEqual(result, 1);
}

-(void)testTableViewNumberOfRowsInSection {
    XCTAssertEqual([self.SUT tableView:self.tableView numberOfRowsInSection:0],3);
}

- (void)testTableViewCellForRowAtIndexPath {
    for(int i=0;i<self.businesses.count;i++){
        UITableViewCell *cell = [self.SUT tableView:self.tableView
                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        XCTAssertEqualObjects(cell.textLabel.text, self.businesses[i].name);
    }
}

- (void)testUpdateBusinesses {
    // Setup
    id<NearbyBusinessesDataSourceDelegate> fakeDelegate = OCMProtocolMock(@protocol(NearbyBusinessesDataSourceDelegate));
    self.SUT.delegate = fakeDelegate;
    
    // Run
    [self.SUT updateBusinesses];
    
    //Verify
    OCMVerify([self.SUT.businessesDataController setDelegate:self.SUT]);
    OCMVerify([self.SUT.businessesDataController updateLocationAndBusinesses]);    

    // Run
    [self.SUT businessesDataControllerDidUpdateBusinesses];
    
    //Verify
    OCMVerify([fakeDelegate nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses]);
}

- (void)testBusinessDataControllerDidFail {
    id<NearbyBusinessesDataSourceDelegate> fakeDelegate = OCMProtocolMock(@protocol(NearbyBusinessesDataSourceDelegate));
    self.SUT.delegate = fakeDelegate;
    
    [self.SUT businessesDataControllerDidFailWithError:nil];
    
    OCMVerify([fakeDelegate nearbyBusinessesDataSourceDidFailWithError:nil]);
}
@end


@interface NearbyBusinessesDataSourceSimplePropertyTests : XCTestCase
@end

@implementation NearbyBusinessesDataSourceSimplePropertyTests
-(void) testBusinessesDataController {
    NearbyBusinessesDataSource *SUT = [NearbyBusinessesDataSource new];
    XCTAssertNotNil(SUT.businessesDataController);
}
@end
