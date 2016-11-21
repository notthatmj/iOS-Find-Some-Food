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
#import "Controller.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
}

-(void)testViewDidLoad {
    Controller *fakeController = OCMPartialMock([Controller new]);
    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc]
                                                initWithController:fakeController];
    [SUT viewDidLoad];
    
    OCMVerify([fakeController startInitialLoad]);
}

//- (void)testNearbyBusinessesDataSourceDidFail {
//    Controller *fakeController = OCMPartialMock([Controller new]);
//    NearbyBusinessesTableViewController *SUT = [[NearbyBusinessesTableViewController alloc]
//                                                initWithController:fakeController];
//    NSError *testError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:nil];
//    [SUT nearbyBusinessesDataSourceDidFailWithError:testError];
//    OCMVerify([fakeController nearbyBusinessesDataSourceDidFailWithError:testError]);
//}

@end
