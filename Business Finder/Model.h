//
//  Model.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationGateway.h"
#import "FourSquareGateway.h"
@class Business;

@protocol ModelObserving <NSObject>
- (void) modelDidUpdateBusinesses;
- (void) modelDidFailWithError:(NSError *)error;
@end

@interface Model : NSObject<LocationGatewayDelegate, FourSquareGatewayDelegate>
@property (weak, nonatomic) id<ModelObserving> observer;
@property (readonly) NSArray<Business *> *businesses;
@property (nonatomic, readonly) double userLatitude;
@property (nonatomic, readonly) double userLongitude;
@property (strong, nonatomic) LocationGateway *locationGateway;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
-(void)updateLocationAndBusinesses;
@end

