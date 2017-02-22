//
//  MapControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/21/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapController.h"
#import "MapViewController.h"
#import "OCMock.h"

@interface MapControllerTests : XCTestCase

@end

@implementation MapControllerTests

- (void)setUp {
    [super setUp];
}

- (void)testConfigureViewController {
    id fakeViewController = OCMClassMock([MapViewController class]);
    MapController *SUT = [[MapController alloc] initWithViewController:fakeViewController];
    int fakeLatitude = 1.0;
    int fakeLongitude = 2.0;
    CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:fakeLatitude longitude:fakeLongitude];
    SUT.businessLocation = fakeLocation;
    SUT.businessName = @"Cyberdyne Systems";
    
    [SUT configureViewController];
    
    OCMVerify([fakeViewController annotateCoordinate:fakeLocation.coordinate withTitle:SUT.businessName]);
    OCMVerify([fakeViewController zoomToCoordinate:fakeLocation.coordinate withRadius:500]);
}

@end
