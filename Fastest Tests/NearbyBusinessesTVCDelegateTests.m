//
//  NearbyBusinessesTVCDelegateTests.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesTVCDelegate.h"
#import "OCMock.h"
#import "NearbyBusinessesTableViewController.h"
#import "BusinessFinderErrorDomain.h"
#import "Business.h"

@interface NearbyBusinessesTVCDelegateTests : XCTestCase
@property (nonatomic, strong) NearbyBusinessesTVCDelegate *SUT;
@property (nonatomic, strong) NearbyBusinessesDataSource *fakeDataSource;
@property (nonatomic, strong) NearbyBusinessesTableViewController *fakeTableViewController;
@property (nonatomic, strong) id aFakeBusiness;
@property (nonatomic, strong) id anotherFakeBusiness;
@property (nonatomic, strong) id fakeTableView;
@end

@implementation NearbyBusinessesTVCDelegateTests

-(void)setUp {
    self.fakeDataSource = OCMClassMock([NearbyBusinessesDataSource class]);
    NearbyBusinessesTableViewController *fakeTableViewController = OCMClassMock([NearbyBusinessesTableViewController class]);
    self.aFakeBusiness = [Business new];
    self.anotherFakeBusiness = [Business new];
    OCMStub([self.fakeDataSource businessAtIndex:0]).andReturn(self.aFakeBusiness);
    OCMStub([self.fakeDataSource businessAtIndex:1]).andReturn(self.anotherFakeBusiness);
    self.fakeTableView = OCMClassMock([UITableView class]);
    OCMStub([self.fakeTableView dataSource]).andReturn(self.fakeDataSource);
    OCMStub([fakeTableViewController tableView]).andReturn(self.fakeTableView);
    self.SUT = [NearbyBusinessesTVCDelegate new];
    self.SUT.dataSource = self.fakeDataSource;
    self.SUT.nearbyBusinessesTableViewController = fakeTableViewController;
}

-(void)testStartInitialLoadAndSuccessfulRetrievalOfBusinesses {
    [self.SUT startInitialLoad];
    
    OCMVerify([self.fakeTableView setDataSource:self.fakeDataSource]);
    OCMVerify([self.fakeDataSource setDelegate:self.SUT]);
    OCMVerify([self.fakeDataSource updateBusinesses]);
    [self.SUT nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
    
    OCMVerify([self.fakeTableView reloadData]);
}

- (void)testNearbyBusinessesDataSourceDidFail {
    NSString *testErrorMessage = @"foobar";
    NSDictionary *testUserInfo = @{NSLocalizedDescriptionKey : testErrorMessage};
    NSError *testError = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                             code:kModelErrorLocation
                                         userInfo:testUserInfo];
    
    // Run
    [self.SUT nearbyBusinessesDataSourceDidFailWithError:testError];
    
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
    OCMVerify([self.fakeTableViewController presentViewController:[OCMArg checkWithBlock:checkAlertController]
                                                    animated:YES
                                                  completion:nil]);
}

- (void)testBusinessAtIndex {
    Business *firstBusiness = [self.SUT businessAtIndex:0];
    Business *secondBusiness = [self.SUT businessAtIndex:1];
    
    XCTAssertEqual(firstBusiness, self.aFakeBusiness);
    XCTAssertEqual(secondBusiness, self.anotherFakeBusiness);
    
}

- (void)testUserLatitudeAndLongitude {
    XCTAssertEqual(self.SUT.userLatitude, 0);
    XCTAssertEqual(self.SUT.userLongitude, 0);
}

- (void)testUserLatitude {
    double fakeLatitude = 42;
    OCMStub(self.fakeDataSource.userLatitude).andReturn(fakeLatitude);

    // Run
    double returnValue = self.SUT.userLatitude;
    
    // Verify
    XCTAssertEqual(returnValue, fakeLatitude);
}

- (void)testUserLongitude {
    double fakeLongitude = 42;
    OCMStub(self.fakeDataSource.userLongitude).andReturn(fakeLongitude);
    
    // Run
    double returnValue = self.SUT.userLongitude;
    
    // Verify
    XCTAssertEqual(returnValue, fakeLongitude);
}

@end
