//
//  GCDGateway.m
//  Business Finder
//
//  Created by Michael Johnson on 9/13/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "GCDGateway.h"

@implementation GCDGateway
+(void)dispatchToMainQueue:(void (^)(void))block {
    dispatch_async(dispatch_get_main_queue(), block);
}
@end
