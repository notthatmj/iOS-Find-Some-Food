//
//  NearbyBusinessesTableViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesTableViewController.h"
#import "Business.h"
#import "LocationGateway.h"
#import "NearbyBusinessesTVCDelegate.h"

@interface NearbyBusinessesTableViewController ()
@end

@implementation NearbyBusinessesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controller == nil) {
        self.controller = [NearbyBusinessesTVCDelegate new];
        self.controller.nearbyBusinessesTableViewController = self;
        self.controller.dataSource = [NearbyBusinessesDataSource new];
    }
    [self.controller startInitialLoad];
}

@end
