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
#import "Model.h"

@interface MapController : NSObject
@property (nonatomic, strong) Business *business;
@property (nonatomic, strong, readonly) Model* model;
- (instancetype) initWithViewController:(MapViewController *)mapViewController;
- (instancetype) initWithViewController:(MapViewController *)mapViewController
                                  model:(Model *)model;
-(void) configureViewController;
@end
