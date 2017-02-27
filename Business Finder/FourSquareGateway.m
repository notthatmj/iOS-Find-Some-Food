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

- (NSArray <NSURLQueryItem *>*) commonQueryItems {
    NSURLQueryItem *cliend_id_item = [NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID];
    NSURLQueryItem *client_secret_item = [NSURLQueryItem queryItemWithName:@"client_secret" value:self.clientSecret];
    NSURLQueryItem *versionItem = [NSURLQueryItem queryItemWithName:@"v" value:@"20130815"];
    return @[cliend_id_item,client_secret_item,versionItem];
}

- (NSString *) searchURLForLatitude:(double) latitude longitude:(double) longitude{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.foursquare.com/v2/venues/search"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.minimumFractionDigits=5;
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:latitude];
    NSString *latitudeString = [formatter stringFromNumber:latitudeNumber];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:longitude];
    NSString *longitudeString = [formatter stringFromNumber:longitudeNumber];
    NSString *latLongString = [NSString stringWithFormat:@"\%@,\%@",latitudeString,longitudeString];
    NSURLQueryItem *latLongItem  = [NSURLQueryItem queryItemWithName:@"ll" value:latLongString];
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"query" value:@""];
    urlComponents.queryItems = [self.commonQueryItems arrayByAddingObjectsFromArray:@[latLongItem,queryItem]];
    NSString *returnValue = [urlComponents string];
    return returnValue;
}

-(NSString *)photosURLForVenueID:(NSString *)venueID {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.foursquare.com/"];
    NSString *path = [NSString stringWithFormat:@"/v2/venues/%@/photos",venueID];
    urlComponents.path = path;
    urlComponents.queryItems = self.commonQueryItems;
    NSString *returnValue = [urlComponents string];
    return returnValue;
}

-(void)getNearbyBusinessesForLatitude:(double)latitude longitude:(double)longitude {
    NSString *searchURL = [self searchURLForLatitude:latitude longitude:longitude];
    [URLFetcher fetchDataForURLString:searchURL completionHandler:^(NSData *data, NSError *error) {
        if (error != nil) {
            [GCDGateway dispatchToMainQueue:^{
                [self.delegate fourSquareGatewayDidFail];
            }];
        } else {
            NSArray<Business *> *businesses = [FourSquareResponseParser parseSearchResponseData:[data copy]];
            self.businesses = businesses;
            [GCDGateway dispatchToMainQueue:^{
                [self.delegate fourSquareGatewayDidFinishGettingBusinesses];
            }];
        }
    }];
    return;
}

-(void)downloadPhotoDictForVenueID:(NSString *)businessID completionHandler:(void (^)(NSDictionary *))completionHandler {
    NSString *url = [self photosURLForVenueID:businessID];
    [URLFetcher fetchDataForURLString:url completionHandler:^(NSData *data, NSError *error) {
        NSDictionary *responseDictionary = [FourSquareResponseParser parsePhotoDictResponseData:data];
        completionHandler(responseDictionary);
    }];
}

-(void)downloadFirstPhotoForVenueID:(NSString *)venueID completionHandler:(void (^)(UIImage *))completionHandler {
    NSString *url = [self getFirstPhotoURLForVenueID:venueID];
    [URLFetcher fetchDataForURLString:url completionHandler:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        completionHandler(image);
    }];
}

-(NSString *)getFirstPhotoURLForVenueID:(NSString *)venueID {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *resultString = nil;
    [self downloadPhotoDictForVenueID:venueID
                    completionHandler:^(NSDictionary *photoDict) {
                        resultString = [FourSquareResponseParser extractPhotoURLFromPhotoDict:photoDict];
                        dispatch_semaphore_signal(semaphore);
                    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultString;
}
@end
