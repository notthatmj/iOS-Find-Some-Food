//
//  NearbyBusinessesTVCDelegate.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesTVCDelegate.h"
#import "NearbyBusinessesTableViewController.h"

@implementation NearbyBusinessesTVCDelegate

- (void)startInitialLoad {
    self.nearbyBusinessesTableViewController.tableView.dataSource = self.dataSource;
    self.dataSource.delegate = self;
    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.nearbyBusinessesTableViewController.tableView reloadData];
    [self.nearbyBusinessesTableViewController endRefreshing];
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self.nearbyBusinessesTableViewController endRefreshing];
    NSString *message = [error localizedDescription];
    NSString *errorTitle = NSLocalizedString(@"Error", @"Title for error alert dialog");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    NSString *actionTitle = NSLocalizedString(@"OK", @"Title for dialog action");
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self.nearbyBusinessesTableViewController presentViewController:alert animated:YES completion:nil];
}

-(void)updateBusinesses {
    [self.dataSource updateBusinesses];
}

-(Business *)businessAtIndex:(NSInteger) index {
    return [self.dataSource businessAtIndex:index];
}

-(double)userLatitude {
    return [self.dataSource userLatitude];
}

-(double)userLongitude {
    return [self.dataSource userLongitude];
}

@end
