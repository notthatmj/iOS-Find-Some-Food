//
//  BusinessesRepository.h
//  Business Finder
//
//  Created by Michael Johnson on 8/2/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BusinessesRepository <NSObject>
-(NSArray *)businesses;
@end

@interface BusinessesRepository : NSObject<BusinessesRepository>

@end