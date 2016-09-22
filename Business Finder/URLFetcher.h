//
//  URLFetcher.h
//  Business Finder
//
//  Created by Michael Johnson on 8/5/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLFetcher : NSObject

//+(void)fetchURLContents:(NSString *)URLString completionHandler: (void (^)(NSString *))completionHandler;
//+(void)fetchURLData:(NSString *)URLString completionHandler: (void (^)(NSData *))completionHandler;
+(void)fetchDataForURLString:(NSString *)urlString
           completionHandler: (void (^)(NSData *data,NSError *error))completionHandler;
@end
