//
//  BusinessCell.m
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell

- (void)setBusiness:(Business *)business {
    _business = business;
    self.textLabel.text = business.name;
    NSString *distanceString = [NSString stringWithFormat:@"%1.2f miles",business.distance];
    self.detailTextLabel.text = distanceString;
    UIImage *image = business.image;
    self.imageView.isAccessibilityElement = YES;
    self.imageView.accessibilityIdentifier = @"photo";
    self.imageView.image = image;
}

@end
