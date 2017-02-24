//
//  Model.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "Model.h"
#import "Business.h"
#import "FourSquareGateway.h"
#import "BusinessFinderErrorDomain.h"

@interface Model ()
@property (strong,nonatomic) NSArray *businesses;
@property (nonatomic) double userLatitude;
@property (nonatomic) double userLongitude;
@property (nonatomic, copy) void (^otherBlock)(void);
@end

@implementation Model

- (instancetype)init {
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
    self.userLongitude = [self.locationGateway.longitude doubleValue];
    self.userLatitude = [self.locationGateway.latitude doubleValue];
    self.fourSquareGateway.delegate = self;
    [self.fourSquareGateway getNearbyBusinessesForLatitude:self.userLatitude longitude:self.userLongitude];
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
                                             code:kModelErrorLocationPermissionDenied
                                         userInfo:userInfo];
        [self.observer modelDidFailWithError:error];
    } else {
        NSString *desc =  NSLocalizedString(@"Unable to retrieve location.", @"");
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                             code:kModelErrorLocation
                                         userInfo:userInfo];
        [self.observer modelDidFailWithError:error];
    }
}

-(void)fourSquareGatewayDidFinishGettingBusinesses {
    NSArray *unsortedBusinesses = [self.fourSquareGateway.businesses copy];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    NSArray <Business *>* businesses = [unsortedBusinesses sortedArrayUsingDescriptors:@[sortDescriptor]];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_group_t downloadGroup = dispatch_group_create();
        for (Business *business in businesses) {
            dispatch_group_enter(downloadGroup);
            [self.fourSquareGateway downloadFirstPhotoForVenueID:business.fourSquareID
                                               completionHandler:^(UIImage *image) {
                                                   business.image = image;
                                                   dispatch_group_leave(downloadGroup);
                                               }];
        }
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.businesses = businesses;
            [self.observer modelDidUpdateBusinesses];
        });
    });
}

-(void)fourSquareGatewayDidFail {
    NSString *desc =  NSLocalizedString(@"Unable to retrieve businesses from the server.", @"");
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
    NSError *error = [NSError errorWithDomain:kBusinessFinderErrorDomain
                                         code:kModelErrorServer
                                     userInfo:userInfo];
    [self.observer modelDidFailWithError:error];
}
@end
