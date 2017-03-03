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
#import "Model.h"
#import "OCMock.h"
#import "NearbyBusinessesTableViewController.h"
#import "BusinessCell.h"
#import "AppDelegate.h"

@interface DummyCellClass : UITableViewCell
@end
@implementation DummyCellClass
@end

@interface NearbyBusinessesDataSourceTests : XCTestCase
@property (nonnull,strong) NearbyBusinessesDataSource *SUT;
@property (strong, nonatomic) NSArray<Business *> *businesses;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Model *fakeModel;
@end

@implementation NearbyBusinessesDataSourceTests

- (Business *) makeBusinessWithName:(NSString *)businessName distance:(float)distance imagedNamed:(NSString *)imageName {
    Business *business = [[Business alloc] initWithName:businessName distance:distance];
    UIImage * image = [UIImage imageNamed:imageName
                                  inBundle:[NSBundle bundleForClass:[self class]]
             compatibleWithTraitCollection:nil];
    business.image = image;
    return business;
}

- (void)setUp {
    [super setUp];
    self.SUT = [NearbyBusinessesDataSource new];
    Business *business1 = [self makeBusinessWithName:@"Larry's Restaurant" distance:1.0 imagedNamed:@"A"];
    Business *business2 = [self makeBusinessWithName:@"Moe's Restaurant" distance:2.0 imagedNamed:@"B"];
    Business *business3 = [self makeBusinessWithName:@"Curly's Restaurant" distance:3.0 imagedNamed:@"C"];
    self.businesses = @[business1,business2,business3];
    self.fakeModel = OCMClassMock([Model class]);
    OCMStub([self.fakeModel businesses]).andReturn(self.businesses);
    self.SUT.model = self.fakeModel;
    
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
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    NSArray<NSString *> *expectedDistanceString = @[@"1.00 miles", @"2.00 miles", @"3.00 miles"];
    for (int i=0; i < [self.businesses count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        BusinessCell *fakeCell = OCMClassMock([BusinessCell class]);
        OCMStub([fakeTableView dequeueReusableCellWithIdentifier:@"PrototypeCell"
                                                    forIndexPath:indexPath]).andReturn(fakeCell);
        
        UITableViewCell *cell = [self.SUT tableView:fakeTableView cellForRowAtIndexPath:indexPath];
        Business *currentBusiness = self.businesses[i];
        
        XCTAssertEqual(fakeCell, cell);
        OCMVerify([fakeCell setBusinessName:currentBusiness.name]);
        OCMVerify([fakeCell setDistanceText:expectedDistanceString[i]]);
        OCMVerify([fakeCell setBusinessImage:currentBusiness.image]);
        OCMVerify([fakeCell setIndexPath:indexPath]);
    }
}

- (void)testUpdateBusinesses {
    // Setup
    id<NearbyBusinessesDataSourceDelegate> fakeDelegate = OCMProtocolMock(@protocol(NearbyBusinessesDataSourceDelegate));
    self.SUT.delegate = fakeDelegate;
    
    // Run
    [self.SUT updateBusinesses];
    
    //Verify
    OCMVerify([self.fakeModel setObserver:self.SUT]);
    OCMVerify([self.fakeModel updateLocationAndBusinesses]);

    // Run
    [self.SUT modelDidUpdateBusinesses];
    
    //Verify
    OCMVerify([fakeDelegate nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses]);
}

- (void)testModelDidFail {
    id<NearbyBusinessesDataSourceDelegate> fakeDelegate = OCMProtocolMock(@protocol(NearbyBusinessesDataSourceDelegate));
    self.SUT.delegate = fakeDelegate;
    
    [self.SUT modelDidFailWithError:nil];
    
    OCMVerify([fakeDelegate nearbyBusinessesDataSourceDidFailWithError:nil]);
}

- (void)testBusinessAtIndex {
    XCTAssertEqual(self.businesses[0], [self.SUT businessAtIndex:0]);
    XCTAssertEqual(self.businesses[1], [self.SUT businessAtIndex:1]);
    XCTAssertEqual(self.businesses[2], [self.SUT businessAtIndex:2]);
}

- (void)testUserLatitude {
    double fakeLatitude = 42;
    OCMStub([self.fakeModel userLatitude]).andReturn(fakeLatitude);
    
    double returnValue = self.SUT.userLatitude;
    
    XCTAssertEqual(returnValue, fakeLatitude);
}

- (void)testUserLongitude {
    double fakeLongitude = 42;
    OCMStub([self.fakeModel userLongitude]).andReturn(fakeLongitude);
    
    double returnValue = self.SUT.userLongitude;
    
    XCTAssertEqual(returnValue, fakeLongitude);
}

@end
