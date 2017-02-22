//
//  NearbyBusinessesDataSource.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesDataSource.h"
#import "Business.h"
#import "LocationGateway.h"
#import "BusinessCell.h"
#import "AppDelegate.h"

@import UIKit;

@interface NearbyBusinessesDataSource ()
@property (strong,nonatomic) void (^completionBlock)();
@end
@implementation NearbyBusinessesDataSource
- (Model *)model {
    if (_model == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _model = appDelegate.model;
    }
    return _model;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger result = self.model.businesses.count;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell" forIndexPath:indexPath];
    Business *business = [self.model businesses][indexPath.row];
    cell.business = business;
    return cell;
}

-(void)updateBusinesses {
    self.model.delegate = self;
    [self.model updateLocationAndBusinesses];
}
-(void)modelDidUpdateBusinesses {
    [self.delegate nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
}

-(void)modelDidFailWithError:(NSError *)error {
    [self.delegate nearbyBusinessesDataSourceDidFailWithError:error];
}

@end
