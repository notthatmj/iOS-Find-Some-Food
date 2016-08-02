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
#import "Business.h"
#import "OCMock.h"

@interface FakeBusinessesRepository : NSObject<BusinessesRepository>

@property (nonatomic, readonly) NSArray* businesses;
-(void)addBusiness:(Business *)business;
@end

@implementation FakeBusinessesRepository

NSMutableArray *_businesses;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _businesses = [NSMutableArray new];
    }
    return self;
}
-(void)addBusiness:(Business *)business {
    [_businesses addObject:business];
}

-(NSArray *)businesses {
    return [_businesses copy];
}

@end

@interface NearbyBusinessesViewControllerTests : XCTestCase
@property (nonatomic, strong) NearbyBusinessesTableViewController *SUT;
@end

@implementation NearbyBusinessesViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *testStoryboard = [UIStoryboard storyboardWithName:@"NearbyBusinessControllerTestsStoryboard" bundle:testBundle];
    self.SUT = [testStoryboard instantiateInitialViewController];
}

- (void)setUpFakeBusinessesRepositoryWithBusinesses: (NSArray<Business *> *) businesses{
    id<BusinessesRepository> fakeBusinessesRepository = OCMProtocolMock(@protocol(BusinessesRepository));
    OCMStub([fakeBusinessesRepository businesses]).andReturn(businesses);
    self.SUT.businessesRepository = fakeBusinessesRepository;
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
    Business *business1 = [[Business alloc] initWithName:@"Larry's Restaurant" distance:1.0];
    Business *business2 = [[Business alloc] initWithName:@"Moe's Restaurant" distance:2.0];
    Business *business3 = [[Business alloc] initWithName:@"Curly's Restaurant" distance:3.0];
    NSArray<Business *> *businesses = @[business1,business2,business3];
    [self setUpFakeBusinessesRepositoryWithBusinesses:businesses];
    
    for(int i=0;i<businesses.count;i++){
        UITableViewCell *cell = [self.SUT tableView:self.SUT.tableView
                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        XCTAssertEqualObjects(cell.textLabel.text, businesses[i].name);
    }
}

-(void)testTableViewNumberOfRowsInSection {
    Business *business1 = [[Business alloc] initWithName:@"Larry's Restaurant" distance:1.0];
    Business *business2 = [[Business alloc] initWithName:@"Moe's Restaurant" distance:2.0];
    [self setUpFakeBusinessesRepositoryWithBusinesses:@[business1,business2]];
    UITableView *dummyTableView = [UITableView new];
    
    XCTAssertEqual([self.SUT tableView:dummyTableView numberOfRowsInSection:0],2);
}

-(void)testViewDidLoad {
    
    [self.SUT viewDidLoad];
    
    XCTAssertNotNil(self.SUT.businessesRepository);
}
@end
