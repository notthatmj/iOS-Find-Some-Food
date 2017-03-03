//
//  MapController.m
//  Business Finder
//
//  Created by Michael Johnson on 2/21/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "MapController.h"
#import "Business.h"
#import "AppDelegate.h"

@interface MapController ()
@property (nonatomic, weak) MapViewController *mapViewController;
@property (nonatomic, strong) Model* model;
@end

@implementation MapController

- (instancetype)initWithViewController:(MapViewController *)mapViewController {
    self = [super init];
    if (self) {
        _mapViewController = mapViewController;
    }
    return self;
}

-(void)configureViewController {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.userLatitude
                                                         longitude:self.userLongitude];
    CLLocation *businessLocation  = [[CLLocation alloc] initWithLatitude:self.business.latitude
                                                               longitude:self.business.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:businessLocation];
    [self.mapViewController annotateCoordinate:businessLocation.coordinate withTitle:self.business.name];
    [self.mapViewController zoomToCoordinate:userLocation.coordinate withRadius:distance];
    [self.mapViewController displayDirectionsToCoordinate:businessLocation.coordinate];
}

@end
