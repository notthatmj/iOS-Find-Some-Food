//
//  MapViewController.h
//  Business Finder
//
//  Created by Michael Johnson on 2/16/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class MapController;

@interface MapViewController : UIViewController
@property (nonatomic, strong) CLLocation* businessLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapController *controller;
- (void)annotateCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int) radius;
@end
