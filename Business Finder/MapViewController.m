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
@property (nonatomic, strong) id<MKOverlay> routeOverlay;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
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

-(void)setUserLatitude:(double)userLatitude {
    self.controller.userLatitude = userLatitude;
}

-(void)setUserLongitude:(double)userLongitude {
    self.controller.userLongitude = userLongitude;
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

-(void)displayDirectionsToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKMapItem *startingPoint = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *endPointPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate];
    MKMapItem *endingPoint = [[MKMapItem alloc] initWithPlacemark:endPointPlacemark];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    directionsRequest.source = startingPoint;
    directionsRequest.destination = endingPoint;
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response,
                                                           NSError * _Nullable error) {
        if (!error && response.routes != nil && response.routes.count > 0) {
            self.routeOverlay = response.routes[0].polyline;
            [self.mapView addOverlay:self.routeOverlay level:MKOverlayLevelAboveRoads];
        }
    }];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5;
    return renderer;
}

@end
