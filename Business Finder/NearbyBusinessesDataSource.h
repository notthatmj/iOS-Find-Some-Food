//
//  NearbyBusinessesDataSource.h
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Model.h"

@protocol NearbyBusinessesDataSourceDelegate <NSObject>
- (void) nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses;
- (void) nearbyBusinessesDataSourceDidFailWithError:(NSError *)error;
@end

@interface NearbyBusinessesDataSource : NSObject <UITableViewDataSource, ModelObserving>
@property (nonatomic, readonly) double userLatitude;
@property (nonatomic, readonly) double userLongitude;
@property (weak,nonatomic) id<NearbyBusinessesDataSourceDelegate> delegate;
-(void)setModel:(Model *)model;
-(void)updateBusinesses;
- (Business *)businessAtIndex:(NSInteger)index;
@end
