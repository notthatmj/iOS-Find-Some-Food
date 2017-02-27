//
//  BusinessCell.h
//  Business Finder
//
//  Created by Michael Johnson on 2/17/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
-(void) setBusinessName:(NSString *)name;
-(void) setDistanceText:(NSString *)text;
-(void) setBusinessImage:(UIImage *)image;
@end
