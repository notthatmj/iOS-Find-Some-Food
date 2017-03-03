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
@class Business;

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapController *controller;
-(void)setBusiness:(Business *)business;
-(void)setUserLatitude:(double)userLatitude;
-(void)setUserLongitude:(double)userLongitude;
- (void)annotateCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title;
- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int) radius;
- (void)displayDirectionsToCoordinate:(CLLocationCoordinate2D)coordinate;
@end
