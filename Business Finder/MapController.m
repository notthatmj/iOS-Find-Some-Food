//
//  MapController.m
//  Business Finder
//
//  Created by Michael Johnson on 2/21/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "MapController.h"

@interface MapController ()
@property (nonatomic, strong) MapViewController *mapViewController;
@end
@implementation MapController
- (instancetype)initWithViewController:(MapViewController *)mapViewController
{
    self = [super init];
    if (self) {
        _mapViewController = mapViewController;
    }
    return self;
}

-(void)configureViewController {
    [self.mapViewController annotateCoordinate:self.businessLocation.coordinate withTitle:self.businessName];
    int radius = 500;
    [self.mapViewController zoomToCoordinate:self.businessLocation.coordinate withRadius:radius];
}

@end
