//
//  FourSquareResponseParser.h
//  Business Finder
//
//  Created by Michael Johnson on 9/13/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Business;

@interface FourSquareResponseParser : NSObject
+(NSArray<Business *> *)parseResponseData:(NSData *)responseData;
@end
