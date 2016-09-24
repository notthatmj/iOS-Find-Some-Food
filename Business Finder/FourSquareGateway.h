//
//  FourSquareGateway.h
//  Business Finder
//
//  Created by Michael Johnson on 8/5/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Business;

@protocol FourSquareGatewayDelegate <NSObject>
-(void)fourSquareGatewayDidFinishGettingBusinesses;
-(void)fourSquareGatewayDidFail;
@end

@interface FourSquareGateway : NSObject
@property (nonatomic, readonly) NSArray<Business *> *businesses;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, weak) NSObject<FourSquareGatewayDelegate> *delegate;
-(void)getNearbyBusinessesForLatitude:(double) latitude longitude:(double)longitude;
@end

