//
//  NearbyBusinessesDataSource.h
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "BusinessesDataController.h"

@interface NearbyBusinessesDataSource : NSObject <UITableViewDataSource,BusinessesDataControllerDelegate>
@property (strong,nonatomic) BusinessesDataController* businessesDataController;
-(void)updateLocationAndBusinessesAndCallBlock:(void(^)(void))block;
@end
