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

-(void)installRefreshControlOnTableView:(UITableView *)tableView selector:(SEL)selector {
    if (self.refreshControl == nil) {
        self.refreshControl = [UIRefreshControl new];
    }
    tableView.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:tableView.dataSource action:selector forControlEvents:UIControlEventValueChanged];
}

-(void)endRefreshing{
    // We use `performSelector:withObject:afterDelay` because it schedules the selector so that its run the next time
    // through the current run loop in the default mode. If we just call the selector directly,
    // the run loop will sometimes be in tracking mode and ignore our request.
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
}

- (void)startInitialLoad {
    self.nearbyBusinessesTableViewController.tableView.dataSource = self.dataSource;
    
    self.dataSource.delegate = self;
    [self installRefreshControlOnTableView:self.nearbyBusinessesTableViewController.tableView selector:@selector(updateBusinesses)];
    [self.refreshControl performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.0];
    [self.nearbyBusinessesTableViewController.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];

    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.nearbyBusinessesTableViewController.tableView reloadData];
    [self endRefreshing];
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self endRefreshing];
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

@end
