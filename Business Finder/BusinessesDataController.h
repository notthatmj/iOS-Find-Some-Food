//
//  BusinessesDataController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationGateway.h"
@class Business;
@class FourSquareGateway;

@interface BusinessesDataController : NSObject<LocationGatewayDelegate>
@property (readonly) NSArray<Business *> *businesses;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (strong, nonatomic) LocationGateway *locationGateway;
//@property (nonatomic, copy) void (^block)(void);
@property (nonatomic) void (^block)(void);
-(void)updateLocationAndBusinessesAndCallBlock:(void(^)(void))block;
-(void)fetchLocationAndCallBlock:(void (^)(void))block;
@end