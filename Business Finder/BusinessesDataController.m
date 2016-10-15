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
#import "BusinessFinderErrorDomain.h"

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

-(FourSquareGateway *)fourSquareGateway {
    if (_fourSquareGateway == nil) {
        _fourSquareGateway = [FourSquareGateway new];
    }
    return _fourSquareGateway;
}

-(void)locationGatewayDidFailWithError:(NSError *)locationError {
    if ([locationError domain] == kCLErrorDomain && [locationError code] == kCLErrorDenied) {
        NSString *desc =  NSLocalizedString(@"Please enable location services in your device settings.", @"");
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                             code:kBusinessesDataControllerErrorLocationPermissionDenied
                                         userInfo:userInfo];
        [self.delegate businessesDataControllerDidFailWithError:error];
    } else {
        NSString *desc =  NSLocalizedString(@"Unable to retrieve location.", @"");
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                             code:kBusinessesDataControllerErrorLocation
                                         userInfo:userInfo];
        [self.delegate businessesDataControllerDidFailWithError:error];
    }
}

-(void)fourSquareGatewayDidFinishGettingBusinesses {
    NSArray *unsortedBusinesses = [self.fourSquareGateway.businesses copy];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    NSArray <Business *>* businesses = [unsortedBusinesses sortedArrayUsingDescriptors:@[sortDescriptor]];
    UIImage *image = [UIImage imageNamed:@"Foobar" inBundle:nil compatibleWithTraitCollection:nil];
    for (Business *business in businesses) {
        business.image = image;
    }
    self.businesses = businesses;
    [self.delegate businessesDataControllerDidUpdateBusinesses];
};

-(void)fourSquareGatewayDidFail {
    NSString *desc =  NSLocalizedString(@"Unable to retrieve businesses from the server.", @"");
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
    NSError *error = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                         code:kBusinessesDataControllerErrorServer
                                     userInfo:userInfo];
    [self.delegate businessesDataControllerDidFailWithError:error];
}
@end
