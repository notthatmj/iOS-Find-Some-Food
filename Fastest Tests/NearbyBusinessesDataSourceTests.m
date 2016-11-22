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
#import "NearbyBusinessesTableViewController.h"

@interface DummyCellClass : UITableViewCell
@end
@implementation DummyCellClass
@end

@interface NearbyBusinessesDataSourceTests : XCTestCase
@property (nonnull,strong) NearbyBusinessesDataSource *SUT;
@property (strong, nonatomic) NSArray<Business *> *businesses;
@property (strong, nonatomic) UITableView *tableView;
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
    UITableView *fakeTableView = OCMClassMock([UITableView class]);
    NSArray *expectedDistanceStrings = @[@"1.00 miles",@"2.00 miles",@"3.00 miles"];
    for (int i=0; i < [self.businesses count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *fakeCell = OCMClassMock([UITableViewCell class]);
        UILabel *fakeTextLabel = OCMClassMock([UILabel class]);
        UILabel *fakeDetailTextLabel = OCMClassMock([UILabel class]);
        UIImageView *fakeImageView = OCMClassMock([UIImageView class]);
        OCMStub([fakeCell textLabel]).andReturn(fakeTextLabel);
        OCMStub([fakeCell detailTextLabel]).andReturn(fakeDetailTextLabel);
        OCMStub([fakeCell imageView]).andReturn(fakeImageView);
        OCMStub([fakeTableView dequeueReusableCellWithIdentifier:@"PrototypeCell"
                                                    forIndexPath:indexPath]).andReturn(fakeCell);
        
        UITableViewCell *cell = [self.SUT tableView:fakeTableView cellForRowAtIndexPath:indexPath];
        Business *currentBusiness = self.businesses[i];

        XCTAssertEqual(fakeCell, cell);
        OCMVerify([fakeTextLabel setText:currentBusiness.name]);
        OCMVerify([fakeDetailTextLabel setText:expectedDistanceStrings[i]]);
        OCMVerify([fakeImageView setIsAccessibilityElement:YES]);
        OCMVerify([fakeImageView setAccessibilityIdentifier:@"photo"]);
        OCMVerify([fakeImageView setImage:currentBusiness.image]);
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
