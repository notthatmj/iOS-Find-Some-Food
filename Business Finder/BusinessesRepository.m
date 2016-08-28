//
//  BusinessesRepository.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "BusinessesRepository.h"
#import "Business.h"


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

-(void)updateBusinesses {
    NSMutableArray *results = [NSMutableArray new];
    NSArray<NSString *> *businessNames = @[@"Trader Joe's",@"Aldi"];
    for (NSString *businessName in businessNames) {
        Business *business = [Business new];
        business.name = businessName;
        business.distance = 1;
        [results addObject:business];
    }
    _businesses = results;
    return;
}

-(void)updateBusinessesAndCallBlock: (void (^)(void)) block {
    [self updateBusinesses];
//    [self.fourSquareGateway getNearbyBusinessesForLatitude:41.884529 longitude:-87.627813 completionHandler:^{}];
    block();
}

@end
