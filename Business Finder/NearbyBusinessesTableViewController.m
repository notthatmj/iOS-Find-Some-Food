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
@property (strong,nonatomic) Controller *controller;
@end

@implementation NearbyBusinessesTableViewController

-(instancetype)init {
    return [self initWithController:nil];
}

-(instancetype)initWithController: (Controller *) controller {
    self = [super init];
    if (self) {
        _controller = controller;
        if (_controller == nil) {
            _controller = [Controller new];
        }
        _controller.nearbyBusinessesTableViewController = self;
        _controller.dataSource = [NearbyBusinessesDataSource new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controller == nil) {
        self.controller = [Controller new];
        self.controller.nearbyBusinessesTableViewController = self;
        self.controller.dataSource = [NearbyBusinessesDataSource new];
    }
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
