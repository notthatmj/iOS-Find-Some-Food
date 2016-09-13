//
//  GCDGateway.h
//  Business Finder
//
//  Created by Michael Johnson on 9/13/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDGateway : NSObject
+(void)dispatchToMainQueue:(void (^)(void))block;
@end
