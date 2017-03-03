//
//  NearbyBusinessesTVCDelegate.h
//  Business Finder
//
//  Created by Michael Johnson on 9/24/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NearbyBusinessesTableViewController;
#import "NearbyBusinessesDataSource.h"

@interface NearbyBusinessesTVCDelegate : NSObject<NearbyBusinessesDataSourceDelegate>
-(void)startInitialLoad;
-(void)updateBusinesses;
-(Business *)businessAtIndex:(NSInteger) index;
// This property is weak because `NearbyBusinessesTableViewController` maintains a strong
// reference to its `NearbyBusinessesTVCDelegate`, and we want to avoid a retain cycle.
@property (weak, nonatomic) NearbyBusinessesTableViewController* nearbyBusinessesTableViewController;
@property (strong, nonatomic) NearbyBusinessesDataSource *dataSource;
@property (nonatomic) double userLatitude;
@property (nonatomic) double userLongitude;
@end
