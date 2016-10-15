//
//  Business.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Business : NSObject

@property (strong,nonatomic) NSString *name;
@property (nonatomic) float distance;
@property (strong,nonatomic) UIImage *image;
-(instancetype) initWithName:(NSString *) name distance:(float) distance;
@end
