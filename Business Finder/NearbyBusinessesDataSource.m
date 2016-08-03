//
//  NearbyBusinessesDataSource.m
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesDataSource.h"
#import "BusinessesRepository.h"

@implementation NearbyBusinessesDataSource
- (id<BusinessesRepository>)businessesRepository {
    if (_businessesRepository == nil) {
        _businessesRepository = [BusinessesRepository new];
    }
    return _businessesRepository;
}
@end
