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

@import UIKit;

@interface NearbyBusinessesDataSource ()
@property (strong,nonatomic) void (^completionBlock)();
@end
@implementation NearbyBusinessesDataSource
- (BusinessesDataController *)businessesDataController {
    if (_businessesDataController == nil) {
        _businessesDataController = [BusinessesDataController new];
    }
    return _businessesDataController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger result = self.businessesDataController.businesses.count;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell" forIndexPath:indexPath];
    Business *business = [self.businessesDataController businesses][indexPath.row];
    cell.textLabel.text = business.name;
    NSString *distanceString = [NSString stringWithFormat:@"%1.2f meters",business.distance];
//    cell.detailTextLabel.text = @"Foobar";
    cell.detailTextLabel.text = distanceString;
    return cell;
}

-(void)updateBusinesses {
    self.businessesDataController.delegate = self;
    [self.businessesDataController updateLocationAndBusinesses];
}
-(void)businessesDataControllerDidUpdateBusinesses {
    [self.delegate nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
}

-(void)businessesDataControllerDidFailWithError:(NSError *)error {
    [self.delegate nearbyBusinessesDataSourceDidFailWithError:error];
}

@end
