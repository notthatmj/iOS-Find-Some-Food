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
    return [self initWithController:nil];
}

-(instancetype)initWithController: (Controller *) controller {
    self = [super init];
    if (self) {
        [self initializeInstanceVariablesWithDataSource:nil controller:controller];
    }
    return self;
}

- (void) initializeInstanceVariablesWithDataSource:(NearbyBusinessesDataSource *)dataSource controller:(Controller *)controller {
    _controller = controller;
    if(dataSource == nil) {
        dataSource = [NearbyBusinessesDataSource new];
    }
    if (_controller == nil) {
        _controller = [Controller new];
    }
    _controller.nearbyBusinessesTableViewController = self;
    _controller.dataSource = dataSource;
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
    [self.controller waitForInitialLoadToComplete];
};
@end
