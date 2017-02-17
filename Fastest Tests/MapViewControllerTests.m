//
//  MapViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapViewController.h"

@interface MapViewControllerTests : XCTestCase

@end

@implementation MapViewControllerTests

- (void)testMapViewController {
    UIStoryboard *SUT = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XCTAssertNotNil(SUT);
    
    MapViewController *mapViewController = [SUT instantiateViewControllerWithIdentifier:@"MapViewController"];
    XCTAssertNotNil(mapViewController);
    XCTAssertNil(mapViewController.businessLocation);
}

@end
