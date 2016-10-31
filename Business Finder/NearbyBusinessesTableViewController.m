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
#import "RefreshController.h"

@interface NearbyBusinessesTableViewController ()
@property (nonatomic, strong, readonly) dispatch_semaphore_t loadSemaphore;
//@property (nonatomic, strong, bool)
@end

@implementation NearbyBusinessesTableViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        _loadSemaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(_loadSemaphore);
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _loadSemaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(_loadSemaphore);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataSource == nil) {
        self.dataSource = [NearbyBusinessesDataSource new];
    }

    if (self.refreshController == nil) {
        self.refreshController = [RefreshController new];
    }
    self.tableView.dataSource = self.dataSource;

    self.dataSource.delegate = self;
    [self.refreshController installRefreshControlOnTableView:self.tableView selector:@selector(updateBusinesses)];
    [self.dataSource updateBusinesses];
}

-(void)nearbyBusinessesDataSourceDidUpdateLocationAndBusinesses {
    [self.tableView reloadData];
    [self.refreshController endRefreshing];
    dispatch_semaphore_signal(self.loadSemaphore);
}

-(void)nearbyBusinessesDataSourceDidFailWithError:(NSError *) error {
    [self.refreshController endRefreshing];
    NSString *message = [error localizedDescription];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_semaphore_signal(self.loadSemaphore);
}

-(void)waitForInitialLoadToComplete {
    dispatch_semaphore_wait(self.loadSemaphore,DISPATCH_TIME_FOREVER);
};
@end
