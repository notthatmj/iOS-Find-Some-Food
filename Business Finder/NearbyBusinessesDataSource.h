//
//  NearbyBusinessesDataSource.h
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
//#import "BusinessesRepository.h"
@class BusinessesRepository;

@interface NearbyBusinessesDataSource : NSObject <UITableViewDataSource>
@property (strong,nonatomic) BusinessesRepository* businessesRepository;
//-(void)updateBusinesses;
@end
