//
//  NearbyBusinessesTableViewController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessesRepository.h"
@class NearbyBusinessFinder;
@class NearbyBusinessesDataSource;

@interface NearbyBusinessesTableViewController : UITableViewController
@property (strong,nonatomic) NearbyBusinessFinder *nearbyBusinessFinder;
@property (strong,nonatomic) NearbyBusinessesDataSource *dataSource;
@end
