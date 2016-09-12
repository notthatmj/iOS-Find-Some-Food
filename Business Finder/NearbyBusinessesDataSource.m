//
//  NearbyBusinessesDataSource.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesDataSource.h"
#import "BusinessesDataController.h"
#import "Business.h"
#import "LocationGateway.h"

@import UIKit;

@implementation NearbyBusinessesDataSource
- (BusinessesDataController *)BusinessesDataController {
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
    return cell;
}

-(void)updateLocationAndBusinessesAndCallBlock:(void(^)(void))block {
    [self.businessesDataController updateLocationAndBusinessesAndCallBlock:block];
}

@end
