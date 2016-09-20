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

@protocol BusinessesDataControllerDelegate <NSObject>

- (void) businessesDataControllerDidUpdateBusinesses;

@end

@interface BusinessesDataController : NSObject<LocationGatewayDelegate,FourSquareGatewayDelegate>
@property (weak, nonatomic) id<BusinessesDataControllerDelegate> delegate;
@property (readonly) NSArray<Business *> *businesses;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (strong, nonatomic) LocationGateway *locationGateway;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
-(void)updateLocationAndBusinesses;
@end

