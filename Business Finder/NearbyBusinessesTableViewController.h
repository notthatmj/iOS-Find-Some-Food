//
//  NearbyBusinessesTableViewController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyBusinessesDataSource.h"
@class NearbyBusinessFinder;
@class LocationGateway;
@class NearbyBusinessesTVCDelegate;

@interface NearbyBusinessesTableViewController : UITableViewController
@property (strong,nonatomic) NearbyBusinessFinder *nearbyBusinessFinder;
@property (strong,nonatomic) NearbyBusinessesTVCDelegate *delegate;
-(void)endRefreshing;
@end
