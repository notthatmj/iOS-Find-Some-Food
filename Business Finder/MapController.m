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
@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) Model* model;
@end

@implementation MapController

- (instancetype)initWithViewController:(MapViewController *)mapViewController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Model *model = appDelegate.model;
    return [self initWithViewController:mapViewController model:model];
}

-(instancetype)initWithViewController:(MapViewController *)mapViewController
                                model:(Model *)model {
    self = [super init];
    if (self) {
        _mapViewController = mapViewController;
        _model = model;
    }
    return self;
}

-(void)configureViewController {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.model.userLatitude
                                                         longitude:self.model.userLongitude];
    CLLocation *businessLocation  = [[CLLocation alloc] initWithLatitude:self.business.latitude
                                                               longitude:self.business.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:businessLocation];
    [self.mapViewController annotateCoordinate:businessLocation.coordinate withTitle:self.business.name];
    [self.mapViewController zoomToCoordinate:userLocation.coordinate withRadius:distance];
    [self.mapViewController displayDirectionsToCoordinate:businessLocation.coordinate];
}

@end
