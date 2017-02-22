//
//  MapViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 2/16/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "MapViewController.h"
#import "BusinessAnnotation.h"
#import "MapController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.controller configureViewController];
}

- (MapController *)controller {
    if (_controller == nil) {
        self.controller = [[MapController alloc] initWithViewController:self];
    }
    return _controller;
}

-(void)setBusiness:(Business *)business {
    self.controller.business = business;
}

- (void)annotateCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title {
    BusinessAnnotation *annotation = [BusinessAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = title;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int) radius {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,
                                                               2*radius,
                                                               2*radius)];
}

@end
