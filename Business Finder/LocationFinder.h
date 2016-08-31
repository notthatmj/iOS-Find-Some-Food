//
//  LocationFinder.h
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationFinder : NSObject
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
-(void)fetchLocationAndCallBlock:(void (^)())block;
@end
