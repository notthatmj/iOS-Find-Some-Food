//
//  BusinessesRepository.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquareGateway.h"

@interface BusinessesRepository : NSObject
@property (readonly) NSArray *businesses;
@property (strong, nonatomic) FourSquareGateway *fourSquareGateway;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
-(void)updateBusinesses;
-(void)updateBusinessesAndCallBlock: (void (^)(void)) block;
@end