//
//  NearbyBusinessesTableViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesTableViewController.h"
#import "Business.h"
#import "BusinessesRepository.h"
#import "NearbyBusinessesDataSource.h"
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

    NearbyBusinessesTableViewController * __weak weakSelf = self;
    [self.dataSource updateLocationAndBusinessesAndCallBlock:^{
        [weakSelf.tableView reloadData];
    }];
}

@end
