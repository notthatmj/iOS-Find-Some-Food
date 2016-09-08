//
//  BusinessesRepository.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "BusinessesRepository.h"
#import "Business.h"
#import "FourSquareGateway.h"
#import "LocationGateway.h"

@interface BusinessesRepository ()
@property (strong,nonatomic) NSArray *businesses;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end

@implementation BusinessesRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _businesses = [NSArray new];
        self.locationGateway = [LocationGateway new];
    }
    return self;
}

-(void)updateBusinessesAndCallBlock: (void (^)(void)) block {
    self.longitude = [self.locationGateway.longitude doubleValue];
    self.latitude = [self.locationGateway.latitude doubleValue];

    [self.fourSquareGateway getNearbyBusinessesForLatitude:self.latitude longitude:self.longitude completionHandler:^{
        NSArray<Business *> *results = self.fourSquareGateway.businesses;
        _businesses = results;
        block();
    }];
}

-(FourSquareGateway *)fourSquareGateway {
    if (_fourSquareGateway == nil) {
        _fourSquareGateway = [FourSquareGateway new];
    }
    return _fourSquareGateway;
}
@end
