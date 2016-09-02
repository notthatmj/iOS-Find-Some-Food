//
//  LocationFinder.m
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "LocationFinder.h"

@interface LocationFinder ()
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end

@implementation LocationFinder
-(void)fetchLocationAndCallBlock:(void (^)())block {
    self.latitude = 1;
    self.longitude = 1;
    block();
}
@end
