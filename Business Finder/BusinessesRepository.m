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

@interface BusinessesRepository ()
@property (strong,nonatomic) NSArray *businesses;
@end

@implementation BusinessesRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _businesses = [NSArray new];
    }
    return self;
}

-(void)updateBusinessesAndCallBlock: (void (^)(void)) block {
    [self.fourSquareGateway getNearbyBusinessesForLatitude:41.884529 longitude:-87.627813 completionHandler:^{
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
