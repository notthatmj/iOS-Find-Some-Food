//
//  BusinessAnnotationTests.m
//  Business Finder
//
//  Created by Michael Johnson on 2/21/17.
//  Copyright © 2017 Michael Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusinessAnnotation.h"
#import <MapKit/MapKit.h>

@interface BusinessAnnotationTests : XCTestCase

@end

@implementation BusinessAnnotationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testBusinessAnnotation {
    id<MKAnnotation> SUT = [BusinessAnnotation new];
    XCTAssertNotNil(SUT);
}

@end
