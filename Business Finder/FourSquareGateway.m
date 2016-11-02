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

-(NSString *)photosURLForVenueID:(NSString *)venueID {
    NSString *s = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=\%@&client_secret=\%@&v=20130815", venueID,self.clientID,self.clientSecret];
    return s;
}

-(void)getNearbyBusinessesForLatitude:(double)latitude longitude:(double)longitude {
    NSString *searchURL = [self searchURLForLatitude:latitude longitude:longitude];
    [URLFetcher fetchDataForURLString:searchURL completionHandler:^(NSData *data, NSError *error) {
        if (error != nil) {
            [GCDGateway dispatchToMainQueue:^{
                [self.delegate fourSquareGatewayDidFail];
            }];
        } else {
            NSArray<Business *> *businesses = [FourSquareResponseParser parseResponseData:[data copy]];
            // For each business in businesses:
            //     Launch a task that fetches additional data for that business and fills out
            //     the business object with the fetche data;
            // Wait until all the above tasks finish and then notify our delegate.
            self.businesses = businesses;
            [GCDGateway dispatchToMainQueue:^{
                [self.delegate fourSquareGatewayDidFinishGettingBusinesses];
            }];
        }
    }];
    return;
}

-(void)downloadPhotoListForVenueID:(NSString *)businessID completionHandler:(void (^)(NSArray *))completionHandler {
    NSString *url = [self photosURLForVenueID:businessID];
    [URLFetcher fetchDataForURLString:url completionHandler:^(NSData *data, NSError *error) {
        completionHandler(@[@"foo"]);
    }];
}
-(void)downloadPhotoDictForVenueID:(NSString *)businessID completionHandler:(void (^)(NSDictionary *))completionHandler {
    NSString *url = [self photosURLForVenueID:businessID];
    [URLFetcher fetchDataForURLString:url completionHandler:^(NSData *data, NSError *error) {
        NSDictionary *responseDictionary = [FourSquareResponseParser parsePhotoDictResponseData:data];
        completionHandler(responseDictionary);
    }];
}

-(UIImage *)downloadFirstPhotoForVenueID:(NSString *)venueID {
    NSString *url = [self getFirstPhotoURLForVenueID:venueID];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block UIImage *image = nil;
    [URLFetcher fetchDataForURLString:url completionHandler:^(NSData *data, NSError *error) {
        image = [UIImage imageWithData:data];
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return image;
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
