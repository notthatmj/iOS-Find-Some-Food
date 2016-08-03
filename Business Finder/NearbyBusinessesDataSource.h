//
//  NearbyBusinessesDataSource.h
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BusinessesRepository.h"
@protocol BusinessesRepository;
@interface NearbyBusinessesDataSource : NSObject
@property (strong,nonatomic) id<BusinessesRepository> businessesRepository;
@end
