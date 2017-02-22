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
    CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake(self.model.userLatitude,
                                                                   self.model.userLongitude);
    CLLocationCoordinate2D businessCoordinate = CLLocationCoordinate2DMake(self.business.latitude,
                                                                           self.business.longitude);
    [self.mapViewController annotateCoordinate:businessCoordinate withTitle:self.business.name];
    int radius = 500;
    [self.mapViewController zoomToCoordinate:userCoordinate withRadius:radius];
}

@end
