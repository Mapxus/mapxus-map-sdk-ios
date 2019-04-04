//
//  MXMGeoPointTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/4/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MXMCommonObj.h"

@interface MXMGeoPointTests : XCTestCase

@end

@implementation MXMGeoPointTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGeoPoint {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    MXMGeoPoint *point = [MXMGeoPoint locationWithLatitude:144.3 longitude:25.9];
    XCTAssertTrue(point.latitude == 144.3, "MXMGeoPoint initialization error");
    XCTAssertTrue(point.longitude == 25.9, "MXMGeoPoint initialization error");
    XCTAssertTrue(point.elevation == 0.0, "MXMGeoPoint initialization error");

    MXMGeoPoint *point2 = [MXMGeoPoint locationWithLatitude:144.3 longitude:25.9 elevation:10.0];
    XCTAssertTrue(point2.latitude == 144.3, "MXMGeoPoint initialization error");
    XCTAssertTrue(point2.longitude == 25.9, "MXMGeoPoint initialization error");
    XCTAssertTrue(point2.elevation == 10.0, "MXMGeoPoint initialization error");
}


@end
