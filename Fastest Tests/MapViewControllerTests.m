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
@end

@implementation MapViewControllerTests

-(void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.SUT = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
}
- (void)testProperties {
    XCTAssertNotNil(self.SUT);
}

- (void)testViewDidLoad {
    id fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = fakeController;
    
    // Load View
    [self.SUT view];
    
    XCTAssertNotNil(self.SUT.mapView);
    OCMVerify([fakeController configureViewController]);
}

- (void)testSetBusiness {
    MapController *fakeController = OCMClassMock([MapController class]);
    self.SUT.controller = fakeController;
    Business *business = [[Business alloc] initWithName:@"Cyberdyne Systems" distance:1.0];

    self.SUT.business = business;
    
    OCMVerify([fakeController setBusiness:business]);
}

@end
