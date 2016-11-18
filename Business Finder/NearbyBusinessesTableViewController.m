//
//  NearbyBusinessesTableViewController.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import "NearbyBusinessesTableViewController.h"
#import "Business.h"
#import "LocationGateway.h"
#import "Controller.h"

@interface NearbyBusinessesTableViewController ()
@end

@implementation NearbyBusinessesTableViewController

-(instancetype)init {
    return [self initWithDataSource:nil controller:nil];
}

-(instancetype)initWithDataSource:(NearbyBusinessesDataSource *)dataSource controller: (Controller *) controller {
    self = [super init];
    if (self) {
        [self initializeInstanceVariablesWithDataSource:dataSource controller:controller];
    }
    return self;
}

- (void) initializeInstanceVariablesWithDataSource:(NearbyBusinessesDataSource *)dataSource controller:(Controller *)controller {
    _loadSemaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_signal(_loadSemaphore);
    _dataSource = dataSource;
    _controller = controller;
    if(_dataSource == nil) {
        _dataSource = [NearbyBusinessesDataSource new];
    }
    if (_controller == nil) {
        _controller = [Controller new];
    }
    _controller.nearbyBusinessesTableViewController = self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeInstanceVariablesWithDataSource:nil controller:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.controller startInitialLoad];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.controller nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses];
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self.controller nearbyBusinessesDataSourceDidFailWithError:error];
}

-(void)waitForInitialLoadToComplete {
    dispatch_semaphore_wait(self.loadSemaphore,DISPATCH_TIME_FOREVER);
};
@end
