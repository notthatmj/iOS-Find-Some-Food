//
//  NearbyBusinessesViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesTableViewController.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase

@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testNearbyBusinessesViewController {
    NearbyBusinessesTableViewController *SUT = [NearbyBusinessesTableViewController new];
    XCTAssertNotNil(SUT);
}
@end
