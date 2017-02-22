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

@interface MapViewControllerTests : XCTestCase
@property (strong, nonatomic) MapViewController *SUT;
@end

@implementation MapViewControllerTests

-(void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.SUT = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
}
- (void)testProperties {
    XCTAssertNotNil(self.SUT);
    XCTAssertNil(self.SUT.businessLocation);
    XCTAssertNil(self.SUT.businessTitle);
}

- (void)testViewDidLoad {
    id fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = fakeController;
    
    // Load View
    [self.SUT view];
    
    XCTAssertNil(self.SUT.businessLocation);
    XCTAssertNotNil(self.SUT.mapView);
    OCMVerify([fakeController configureViewController]);
}

- (void)testSetBusinessLocation {
    MapController *fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = fakeController;
    
    CLLocation *businessLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    self.SUT.businessLocation = businessLocation;
    
    OCMVerify([fakeController setBusinessLocation:businessLocation]);
}

- (void)testSetBusinessName {
    MapController *fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = fakeController;
    
    NSString *businessName = @"Cyberdyne Systems";
    self.SUT.businessTitle = businessName;
    
    OCMVerify([fakeController setBusinessName:businessName]);
}

@end
