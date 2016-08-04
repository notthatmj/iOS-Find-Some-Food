//
//  NearbyBusinessesDataSource.h
//  Business Finder
//
//  Created by Michael Johnson on 8/3/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
//@class UITableView;
//@class UITableViewCell;

//#import "BusinessesRepository.h"
@protocol BusinessesRepository;
@interface NearbyBusinessesDataSource : NSObject <UITableViewDataSource>
@property (strong,nonatomic) id<BusinessesRepository> businessesRepository;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
