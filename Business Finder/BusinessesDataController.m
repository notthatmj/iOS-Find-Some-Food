//
//  BusinessesDataController.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "BusinessesDataController.h"
#import "Business.h"
#import "FourSquareGateway.h"

@interface BusinessesDataController ()
@property (strong,nonatomic) NSArray *businesses;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) void (^otherBlock)(void);
@end

@implementation BusinessesDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _businesses = [NSArray new];
        self.locationGateway = [LocationGateway new];
    }
    return self;
}

-(void)updateLocationAndBusinesses {
    self.locationGateway.delegate = self;
    [self.locationGateway fetchLocation];
}

-(void)locationGatewayDidUpdateLocation:(LocationGateway *)locationGateway {
    self.longitude = [self.locationGateway.longitude doubleValue];
    self.latitude = [self.locationGateway.latitude doubleValue];
    self.fourSquareGateway.delegate = self;
    [self.fourSquareGateway getNearbyBusinessesForLatitude:self.latitude longitude:self.longitude];
}

-(void)locationGatewayDidFail {
    [self.delegate businessesDataControllerDidFail];
}

-(FourSquareGateway *)fourSquareGateway {
    if (_fourSquareGateway == nil) {
        _fourSquareGateway = [FourSquareGateway new];
    }
    return _fourSquareGateway;
}

-(void)fourSquareGatewayDidFinishGettingBusinesses {
    self.businesses = [self.fourSquareGateway.businesses copy];
    [self.delegate businessesDataControllerDidUpdateBusinesses];
}
@end
