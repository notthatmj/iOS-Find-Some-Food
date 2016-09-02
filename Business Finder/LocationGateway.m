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
-(void) fetchLocationAndCallBlock: (void (^)())block {
    self.completionHandler = block;
    self.locationManager.delegate = self;
    CLAuthorizationStatus authorizationStatus= [LocationGateway authorizationStatus];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self requestWhenInUseAuthorization];
    } else {
        [self.locationManager requestLocation];
//        [self.locationManager startUpdatingLocation];
    }
//    block();
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.latitude = [NSNumber numberWithDouble:55.0];
    self.longitude = [NSNumber numberWithDouble:55.0];
    
    self.completionHandler();
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    self.completionHandler();
}

+(CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

-(void)requestWhenInUseAuthorization {
    [self.locationManager requestWhenInUseAuthorization];
}
@end
