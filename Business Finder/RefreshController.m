//
//  RefreshController.m
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "RefreshController.h"
#import "NearbyBusinessesDataSource.h"

@implementation RefreshController

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

@end
