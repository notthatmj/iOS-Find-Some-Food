//
//  BusinessesDataController.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Business;
@class FourSquareGateway;
@class LocationGateway;

@interface BusinessesDataController : NSObject
@property (readonly) NSArray<Business *> *businesses;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (strong, nonatomic) LocationGateway *locationGateway;
-(void)updateLocationAndBusinessesAndCallBlock:(void(^)(void))block;

@end