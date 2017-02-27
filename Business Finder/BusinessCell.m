//
//  BusinessCell.m
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell

-(void)setBusinessName:(NSString *)businessName {
    self.textLabel.text = businessName;
}

-(void)setDistanceText:(NSString *)distanceText {
    self.detailTextLabel.text = distanceText;
}

-(void) setBusinessImage:(UIImage *)image {
    self.imageView.isAccessibilityElement = YES;
    self.imageView.accessibilityIdentifier = @"photo";
    self.imageView.image = image;
}

@end
