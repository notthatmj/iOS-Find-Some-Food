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
    self.dataSource.businessesRepository.latitude = 41.840457;
    self.dataSource.businessesRepository.longitude = -87.660502;
    self.locationGateway = [LocationGateway new];
//    [self.locationGateway requestWhenInUseAuthorization];
    [self.locationGateway fetchLocationAndCallBlock:^{
        NSLog(@"Well, at least we made it here.");
    }];
    NearbyBusinessesTableViewController * __weak weakSelf = self;
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
