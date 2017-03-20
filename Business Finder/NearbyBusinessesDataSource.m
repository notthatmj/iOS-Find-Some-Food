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
@property (strong,nonatomic) Model* model;
@end
@implementation NearbyBusinessesDataSource
- (Model *)model {
    if (_model == nil) {
        _model = [Model new];
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

- (Business *)businessAtIndex:(NSInteger)index {
    return [self.model businesses][index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell" forIndexPath:indexPath];
    Business *business = [self businessAtIndex:indexPath.row];
    cell.businessName = business.name;
    NSString *distanceString = [NSString stringWithFormat:@"%1.2f miles",business.distance];
    cell.distanceText = distanceString;
    UIImage *image = business.image;
    [cell setBusinessImage:image];
    [cell setIndexPath:indexPath];
    return cell;
}

-(void)updateBusinesses {
    self.model.observer = self;
    [self.model updateLocationAndBusinesses];
}
-(void)modelDidUpdateBusinesses {
    [self.delegate nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
}

-(void)modelDidFailWithError:(NSError *)error {
    [self.delegate nearbyBusinessesDataSourceDidFailWithError:error];
}

- (double)userLatitude {
    return self.model.userLatitude;
}

- (double)userLongitude {
    return self.model.userLongitude;
}

@end
