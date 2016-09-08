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
    
    self.tableView.dataSource = self.dataSource;

    NearbyBusinessesTableViewController * __weak weakSelf = self;
//    [self.dataSource.businessesRepository.locationGateway fetchLocationAndCallBlock:^{
//        [weakSelf updateBusinesses];
//    }];
}

-(void)updateBusinesses {
    NearbyBusinessesTableViewController * __weak weakSelf = self;
//    self.dataSource.businessesRepository.longitude = [self.dataSource.businessesRepository.locationGateway.longitude doubleValue];
//    self.dataSource.businessesRepository.latitude = [self.dataSource.businessesRepository.locationGateway.latitude doubleValue];

    [self.dataSource.businessesRepository updateBusinessesAndCallBlock:^{
        [weakSelf.tableView reloadData];
    }];
}

-(NearbyBusinessesDataSource *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NearbyBusinessesDataSource new];
    }
    return _dataSource;
}

@end
