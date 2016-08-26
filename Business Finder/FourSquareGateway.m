//
//  FourSquareGateway.m
//  Business Finder
//
//  Created by Michael Johnson on 8/5/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "FourSquareGateway.h"
#import "URLFetcher.h"

@implementation FourSquareGateway
-(void)getNearbyBusinessesForLatitude:(double)latitude longitude:(double)longitude completionHandler:(void (^)())completionHandler {
    completionHandler();
}

- (NSString *) searchURLForLatitude:(double) latitude longitude:(double) longitude{
    NSString *formatString = @"https://api.foursquare.com/v2/venues/search?client_id=\%@&client_secret=\%@&v=20130815&ll=\%@,\%@&query=sushi";
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.minimumFractionDigits=5;
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:latitude];
    NSString *latitudeString = [formatter stringFromNumber:latitudeNumber];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:longitude];
    NSString *longitudeString = [formatter stringFromNumber:longitudeNumber];
    
    return [NSString stringWithFormat:formatString,@"foo",@"bar",latitudeString,longitudeString];
}

-(void)getResponseForSearchURL:(NSString *)searchURL completionHandler:(void (^)())completionHandler {
    [URLFetcher fetchURLContents:searchURL completionHandler:^void (NSString *response){
        self.response = [response copy];
        completionHandler();
        return;
    }];
    return;
}

-(NSArray<Business *> *)parseQueryResponse {
    NSData *data = [self.response dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    result = [NSArray new];
    return result;
}
@end
