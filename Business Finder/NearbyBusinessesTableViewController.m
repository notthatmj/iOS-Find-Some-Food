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
#import "RefreshController.h"

@interface NearbyBusinessesTableViewController ()

@end

@implementation NearbyBusinessesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataSource == nil) {
        self.dataSource = [NearbyBusinessesDataSource new];
    }

    if (self.refreshController == nil) {
        self.refreshController = [RefreshController new];
    }
    self.tableView.dataSource = self.dataSource;

    self.dataSource.delegate = self;
    [self.refreshController installRefreshControlOnTableView:self.tableView selector:@selector(updateBusinesses)];
    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.tableView reloadData];
    [self.refreshController endRefreshing];
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self.refreshController endRefreshing];
    NSString *message = [error localizedDescription];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
