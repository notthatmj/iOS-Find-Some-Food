//
//  NearbyBusinessesDataSource.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesDataSource.h"
#import "BusinessesRepository.h"
#import "Business.h"
@import UIKit;

@implementation NearbyBusinessesDataSource
- (BusinessesRepository *)businessesRepository {
    if (_businessesRepository == nil) {
        _businessesRepository = [BusinessesRepository new];
    }
    return _businessesRepository;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger result = self.businessesRepository.businesses.count;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrototypeCell" forIndexPath:indexPath];
    Business *business = [self.businessesRepository businesses][indexPath.row];
    cell.textLabel.text = business.name;
    return cell;
}

//-(void)updateBusinesses {
////    NearbyBusinessesTableViewController * __weak weakSelf = self;
//    self.businessesRepository.longitude = [self.locationGateway.longitude doubleValue];
//    self.dataSource.businessesRepository.latitude = [self.locationGateway.latitude doubleValue];
//    
//    [self.dataSource.businessesRepository updateBusinessesAndCallBlock:^{
//        [weakSelf.tableView reloadData];
//    }];
//}

@end
