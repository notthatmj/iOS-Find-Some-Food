//
//  FourSquareResponseParser.m
//  Business Finder
//
//  Created by Michael Johnson on 9/13/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "FourSquareResponseParser.h"
#import "Business.h"

@implementation FourSquareResponseParser
+(NSArray<Business *> *)parseResponseData:(NSData *)responseData {
    NSData *data = responseData;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *responseDictionary = [JSONDictionary objectForKey:@"response"];
    NSArray *venues = [responseDictionary objectForKey:@"venues"];
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *venueDictionary in venues) {
        Business *business = [Business new];
        business.name = [venueDictionary valueForKey:@"name"];
        business.fourSquareID = [venueDictionary valueForKey:@"id"];
        NSDictionary *locationDictionary = [venueDictionary valueForKey:@"location"];
        NSNumber *distance = [locationDictionary valueForKey:@"distance"];
        const float metersPerMile = 1609.344;
        business.distance = [distance floatValue] / metersPerMile ;
        [result addObject:business];
    }
    return  [NSArray arrayWithArray:result];
}
+(NSDictionary *)parsePhotoDictResponseData:(NSData *)responseData {
    NSData *data = responseData;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return JSONDictionary;
}
@end
