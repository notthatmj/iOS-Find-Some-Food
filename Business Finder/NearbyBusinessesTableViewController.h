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
@property (strong,nonatomic,readonly) NearbyBusinessesDataSource *dataSource;
@property (strong,nonatomic) Controller *controller;
@property (nonatomic, strong, readonly) dispatch_semaphore_t loadSemaphore;
-(void)waitForInitialLoadToComplete;
-(instancetype)initWithDataSource:(NearbyBusinessesDataSource *)dataSource;
@end
