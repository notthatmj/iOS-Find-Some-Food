//
//  Controller.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "Controller.h"
#import "NearbyBusinessesTableViewController.h"

@implementation Controller

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loadSemaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(_loadSemaphore);
    }
    return self;
}

-(void)installRefreshControlOnTableView:(UITableView *)tableView selector:(SEL)selector {
    self.refreshControl = [UIRefreshControl new];
    tableView.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:tableView.dataSource action:selector forControlEvents:UIControlEventValueChanged];
}

-(void)beginRefreshing{
    // We use `performSelector:withObject:afterDelay` because it schedules the selector so that its run the next time
    // through the current run loop in the default mode. If we just call the selector directly,
    // the run loop will sometimes be in tracking mode and ignore our request.
    [self.refreshControl performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.0];
}

-(void)endRefreshing{
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
}

- (void)startInitialLoad {
    self.nearbyBusinessesTableViewController.tableView.dataSource = self.dataSource;
    
    self.dataSource.delegate = self.nearbyBusinessesTableViewController;
    [self installRefreshControlOnTableView:self.nearbyBusinessesTableViewController.tableView selector:@selector(updateBusinesses)];
    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.nearbyBusinessesTableViewController.tableView reloadData];
    [self.nearbyBusinessesTableViewController.controller endRefreshing];
    dispatch_semaphore_signal(self.loadSemaphore);
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self endRefreshing];
    NSString *message = [error localizedDescription];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self.nearbyBusinessesTableViewController presentViewController:alert animated:YES completion:nil];
    dispatch_semaphore_signal(self.loadSemaphore);
}

-(void)waitForInitialLoadToComplete {
    dispatch_semaphore_wait(self.loadSemaphore,DISPATCH_TIME_FOREVER);
};

@end
