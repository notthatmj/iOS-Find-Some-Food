//
//  MapController.h
//  Business Finder
//
//  Created by Michael Johnson on 2/21/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapController : NSObject
@property (nonatomic, strong) CLLocation *businessLocation;
- (instancetype) initWithViewController:(MapViewController *)mapViewController;
-(void) configureViewController;
@end
