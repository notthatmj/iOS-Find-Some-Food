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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *SUT = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    XCTAssertNotNil(SUT);
    XCTAssertNil(SUT.businessLocation);
    
    [SUT view];
    
    XCTAssertNotNil(SUT.mapView);
}

@end
