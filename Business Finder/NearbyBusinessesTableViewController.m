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
    if (self.delegate == nil) {
        self.delegate = [NearbyBusinessesTVCDelegate new];
        self.delegate.nearbyBusinessesTableViewController = self;
        self.delegate.dataSource = [NearbyBusinessesDataSource new];
    }
    [self.delegate startInitialLoad];
}

@end
