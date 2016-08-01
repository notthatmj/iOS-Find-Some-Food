//
//  NearbyBusinessesViewControllerTests.m
//  Business Finder
//
//  Created by Michael Johnson on 8/1/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyBusinessFinder.h"
#import "NearbyBusinessesTableViewController.h"
#import "OCMock.h"

@interface NearbyBusinessesViewControllerTests : XCTestCase
@property (nonatomic, strong) NearbyBusinessesTableViewController *SUT;
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.SUT = [NearbyBusinessesTableViewController new];
}

- (void)testNearbyBusinessesViewController {
    XCTAssertNotNil(self.SUT);
}

- (void)testNumberOfSectionsInTableView {
    UITableView *dummyTableView = [UITableView new];
    NSInteger numberOfSections = [self.SUT numberOfSectionsInTableView:dummyTableView];
    XCTAssertEqual(numberOfSections, 1);
}

- (void)testTableViewCellForRowAtIndexPath {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *testStoryboard = [UIStoryboard storyboardWithName:@"NearbyBusinessControllerTestsStoryboard" bundle:testBundle];
    self.SUT = [testStoryboard instantiateInitialViewController];
    NSArray <NSString *> *entryTextStrings = @[@"Larry",@"Moe",@"Curly"];
    for (int i = 0; i<=2; i++) {
        UITableViewCell *cell = [self.SUT tableView:self.SUT.tableView
                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        XCTAssertEqualObjects(cell.textLabel.text, entryTextStrings[i]);
    }
}
@end
