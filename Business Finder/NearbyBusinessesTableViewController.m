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
    [self.dataSource updateLocationAndBusinessesAndNotifyDelegate];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.tableView reloadData];
}
//-(void)NearbyBusinessesDataSourceDidFailWithError:(NSError *)error {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"An Alert" message:@"The Alert" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *defaultAction = [UIAlertAction
//                                    actionWithTitle:@"OK"
//                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
//}

@end
