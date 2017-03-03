//
//  MapViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapViewController.h"
#import "MapController.h"
#import "OCMock.h"
#import "Business.h"

@interface MapViewControllerTests : XCTestCase
@property (strong, nonatomic) MapViewController *SUT;
@property (strong, nonatomic) MapController *fakeController;
@end

@implementation MapViewControllerTests

-(void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.SUT = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    self.fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = self.fakeController;
}
- (void)testInstantiation {
    XCTAssertNotNil(self.SUT);
}

- (void)testViewDidLoad {
    // Load View
    [self.SUT view];
    
    XCTAssertNotNil(self.SUT.mapView);
    OCMVerify([self.fakeController configureViewController]);
}

- (void)testSetBusiness {
    Business *business = [[Business alloc] initWithName:@"Cyberdyne Systems" distance:1.0];

    self.SUT.business = business;
    
    OCMVerify([self.fakeController setBusiness:business]);
}

- (void)testSetUserLatitude {
    double fakeLatitude = 13;
    
    [self.SUT setUserLatitude:fakeLatitude];
    
    OCMVerify([self.fakeController setUserLatitude:fakeLatitude]);
}

- (void)testSetUserLongitude {
    double fakeLongitude = 13;
    
    [self.SUT setUserLongitude:fakeLongitude];
    
    OCMVerify([self.fakeController setUserLongitude:fakeLongitude]);
}

@end
