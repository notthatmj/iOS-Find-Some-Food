//
//  MapViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 2/16/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zoomToLocation:self.businessLocation withRadius:500];
}

- (void)zoomToLocation:(CLLocation *)location withRadius:(CLLocationDistance) radius {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 2*radius, 2*radius)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
