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
@class Controller;

@interface NearbyBusinessesTableViewController : UITableViewController<NearbyBusinessesDataSourceDelegate>
@property (strong,nonatomic) NearbyBusinessFinder *nearbyBusinessFinder;
@property (strong,nonatomic,readonly) Controller *controller;
-(void)waitForInitialLoadToComplete;
-(instancetype)initWithDataSource:(NearbyBusinessesDataSource *)dataSource controller:(Controller *)controller;
@end
