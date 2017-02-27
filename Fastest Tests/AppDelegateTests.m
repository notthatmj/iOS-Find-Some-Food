//
//  AppDelegateTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/23/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests

- (void)testModel {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    XCTAssertNotNil(delegate.model);
}

@end
