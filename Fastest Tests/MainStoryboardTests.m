//
//  MainStoryboardTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessesTableViewController.h"
@interface MainStoryboardTests : XCTestCase

@end

@implementation MainStoryboardTests

- (void)testInitialViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    UIViewController *initialViewController = [SUT instantiateInitialViewController];
    XCTAssert([initialViewController isKindOfClass:[NearbyBusinessesTableViewController class]]);
}

@end
