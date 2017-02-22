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
@property (nonatomic, copy) CLLocation* businessLocation;
@property (nonatomic, copy) NSString* businessTitle;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapController *controller;
- (void)annotateCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title;
- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(int) radius;
@end
