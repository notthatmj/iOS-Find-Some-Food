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
    [self.refreshControl beginRefreshing];
}

-(void)endRefreshing{
    [self.refreshControl endRefreshing];
}

@end
