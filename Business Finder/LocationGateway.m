//
//  LocationGateway.m
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "LocationGateway.h"

@interface LocationGateway ()
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (nonatomic) BOOL fetchingLocation;
@end

@implementation LocationGateway
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.latitude = [NSNumber numberWithDouble:locations[0].coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:locations[0].coordinate.longitude];
    [self.delegate locationGatewayDidUpdateLocation:self];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.fetchingLocation) {
        [self.delegate locationGatewayDidFailWithError:error];
    }
    self.fetchingLocation = NO;
}

+(CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

-(void)requestWhenInUseAuthorization {
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)fetchLocation {
    self.locationManager.delegate = self;
    CLAuthorizationStatus authorizationStatus= [LocationGateway authorizationStatus];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(authorizationStatus == kCLAuthorizationStatusNotDetermined ||
       authorizationStatus == kCLAuthorizationStatusDenied) {
        [self requestWhenInUseAuthorization];
    }
    self.fetchingLocation = true;
    [self.locationManager requestLocation];
}
@end
