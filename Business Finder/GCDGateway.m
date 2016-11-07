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
+(void)asynchronouslyDispatchBlock:(dispatch_block_t)block withQOS:(long)QOS {
    dispatch_async(dispatch_get_global_queue(QOS, 0), block);
}
@end
