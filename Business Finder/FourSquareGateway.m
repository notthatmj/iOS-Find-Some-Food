//
//  FourSquareGateway.m
//  Business Finder
//
//  Created by Michael Johnson on 8/5/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "FourSquareGateway.h"
#import "URLFetcher.h"
#import "Business.h"
#import "FourSquareResponseParser.h"
#import "GCDGateway.h"

@interface FourSquareGateway ()
@property (nonatomic, readwrite) NSArray<Business *> *businesses;
@end

@implementation FourSquareGateway

-(NSString *)clientID {
    if (_clientID == nil) {
        _clientID = @"KYZDFPBI4QBZA5RYW0KHIARABCHACXQU55CVJLHR3YFKLB0B";
    }
    return _clientID;
}

- (NSString *)clientSecret {
    if (_clientSecret == nil) {
        _clientSecret = @"F40OVIFWPTKBVTKO4LWU13F5JLOZHNPIB1DW1XU2UFBDLXXZ";
    }
    return _clientSecret;
}

- (NSString *) searchURLForLatitude:(double) latitude longitude:(double) longitude{
    NSString *formatString = @"https://api.foursquare.com/v2/venues/search?client_id=\%@&client_secret=\%@&v=20130815&ll=\%@,\%@&query=sushi";
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.minimumFractionDigits=5;
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:latitude];
    NSString *latitudeString = [formatter stringFromNumber:latitudeNumber];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:longitude];
    NSString *longitudeString = [formatter stringFromNumber:longitudeNumber];
    return [NSString stringWithFormat:formatString,self.clientID,self.clientSecret,latitudeString,longitudeString];
}

-(void)getNearbyBusinessesForLatitude:(double)latitude longitude:(double)longitude {
    NSString *searchURL = [self searchURLForLatitude:latitude longitude:longitude];
    [URLFetcher fetchDataForURLString:searchURL completionHandler:^(NSData *data, NSError *error) {
        if (error != nil) {
            [GCDGateway dispatchToMainQueue:^{
                [self.delegate fourSquareGatewayDidFail];
            }];
        }
        self.responseData = [data copy];
        NSArray<Business *> *businesses = [FourSquareResponseParser parseResponseData:[data copy]];
        self.businesses = businesses;
        [GCDGateway dispatchToMainQueue:^{
            [self.delegate fourSquareGatewayDidFinishGettingBusinesses];
        }];
    }];
    return;
}
@end
