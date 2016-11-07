//
//  Business.m
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "Business.h"

@implementation Business
- (instancetype)initWithName:(NSString *)name distance:(float)distance {
    self = [super init];
    if (self) {
        _name = name;
        _distance = distance;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat: @"Business: name=%@ distance=%f", self.name, self.distance];
}

@end
