//
//  NearbyBusinessesTableViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesTableViewController.h"
#import "NearbyBusinessesController.h"
#import "MapViewController.h"
#import "BusinessCell.h"

@interface NearbyBusinessesTableViewController ()
@property (nonatomic) BOOL hasStartedInitialLoad;
@end

@implementation NearbyBusinessesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controller == nil) {
        self.controller = [NearbyBusinessesController new];
        self.controller.nearbyBusinessesTableViewController = self;
        self.controller.dataSource = [NearbyBusinessesDataSource new];
    }
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self.controller
                            action:@selector(updateBusinesses)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)endRefreshing{
    // We use `performSelector:withObject:afterDelay` because it schedules the selector so that its run the next time
    // through the current run loop in the default mode. If we just call the selector directly,
    // the run loop will sometimes be in tracking mode and ignore our request.
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.hasStartedInitialLoad) {
        [self.refreshControl beginRefreshing];
        CGFloat offset = self.tableView.contentOffset.y-self.refreshControl.frame.size.height;
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
        [self.controller startInitialLoad];
        self.hasStartedInitialLoad = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapViewController = segue.destinationViewController;
    BusinessCell *cell = sender;
    mapViewController.business = [self.controller businessAtIndex:cell.indexPath.row];
    mapViewController.userLatitude = self.controller.userLatitude;
    mapViewController.userLongitude = self.controller.userLongitude;
}

@end
