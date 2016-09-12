//
//  NearbyBusinessesTableViewController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NearbyBusinessFinder;
@class NearbyBusinessesDataSource;
@class LocationGateway;

@interface NearbyBusinessesTableViewController : UITableViewController
@property (strong,nonatomic) NearbyBusinessFinder *nearbyBusinessFinder;
@property (strong,nonatomic) NearbyBusinessesDataSource *dataSource;
@end
