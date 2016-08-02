//
//  BusinessesRepository.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "BusinessesRepository.h"
#import "Business.h"

@implementation BusinessesRepository

- (NSArray *)businesses {
    NSMutableArray *results = [NSMutableArray new];
    [results addObject:[Business new]];
    [results addObject:[Business new]];
    [results addObject:[Business new]];
    return results;
}

@end
