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
        NSString *venueName = [venueDictionary valueForKey:@"name"];
        NSDictionary *locationDictionary = [venueDictionary valueForKey:@"location"];
        NSNumber *distance = [locationDictionary valueForKey:@"distance"];
        
        Business *business = [Business new];
        business.name = venueName;
        business.distance = [distance floatValue];
        [result addObject:business];
    }
    return  [NSArray arrayWithArray:result];
}
@end
