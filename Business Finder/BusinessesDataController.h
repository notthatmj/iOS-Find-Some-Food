//
//  BusinessesDataController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationGateway.h"
#import "FourSquareGateway.h"
@class Business;

@interface BusinessesDataController : NSObject<LocationGatewayDelegate,FourSquareGatewayDelegate>
@property (readonly) NSArray<Business *> *businesses;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (strong, nonatomic) LocationGateway *locationGateway;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
-(void)updateLocationAndBusinessesAndCallBlock:(void(^)(void))block;
@end