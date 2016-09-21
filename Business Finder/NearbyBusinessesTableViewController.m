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

@interface NearbyBusinessesTableViewController ()

@end

@implementation NearbyBusinessesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataSource == nil) {
        self.dataSource = [NearbyBusinessesDataSource new];
    }

    self.tableView.dataSource = self.dataSource;

    self.dataSource.delegate = self;
    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.tableView reloadData];
}

@end
