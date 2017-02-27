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
+(NSArray<Business *> *)parseSearchResponseData:(NSData *)responseData {
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
        NSNumber *latitude = [locationDictionary valueForKey:@"lat"];
        business.latitude = [latitude doubleValue];
        NSNumber *longitude = [locationDictionary valueForKey:@"lng"];
        business.longitude = [longitude doubleValue];
        [result addObject:business];
    }
    return  [NSArray arrayWithArray:result];
}
+(NSDictionary *)parsePhotoDictResponseData:(NSData *)responseData {
    NSData *data = responseData;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return JSONDictionary;
}

+(NSString *)extractPhotoURLFromPhotoDict:(NSDictionary *)photoDict {
    NSArray *itemsList = photoDict[@"response"][@"photos"][@"items"];
    if ([itemsList count] == 0) {
        return nil;
    }
    NSDictionary *photoEntry = itemsList[0];
    NSString *prefixString = photoEntry[@"prefix"];
    NSString *suffixString = photoEntry[@"suffix"];
    NSString *sizeSpecifier = @"100x100";
    NSString *resultString = [[prefixString stringByAppendingString:sizeSpecifier] stringByAppendingString:suffixString];
    return resultString;
}
@end
