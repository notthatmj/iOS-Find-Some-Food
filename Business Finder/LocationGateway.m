//
//  LocationGateway.m
//  Business Finder
//
//  Created by Michael Johnson on 8/30/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "LocationGateway.h"

@interface LocationGateway ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^completionHandler)();
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@end

@implementation LocationGateway
- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.latitude = [NSNumber numberWithDouble:locations[0].coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:locations[0].coordinate.longitude];
    if (self.completionHandler != nil) {
        self.completionHandler();
    }
    [self.delegate locationGatewayDidUpdateLocation:self];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.delegate locationGatewayDidFail];
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
    if(authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self requestWhenInUseAuthorization];
    } else {
        [self.locationManager requestLocation];
    }
}
@end
