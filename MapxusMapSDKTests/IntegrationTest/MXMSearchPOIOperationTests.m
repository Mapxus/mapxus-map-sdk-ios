//
//  MXMSearchPOIOperationTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/4/3.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MXMSearchPOIOperation.h"


@interface MXMSearchPOIOperationTests : XCTestCase {
    NSOperationQueue *_initializeQueue;
    XCTestExpectation *successExpectation;
}

@end

@implementation MXMSearchPOIOperationTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _initializeQueue = [[NSOperationQueue alloc] init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSearchPOIOperation {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    successExpectation = [self expectationWithDescription:@"testRouteSearchFunction"];

    MXMSearchPOIOperation *searchPoiOp = [[MXMSearchPOIOperation alloc] initWithPoiId:@"74216"];
    searchPoiOp.complateBlock = ^(NSString * _Nonnull buildingId, NSString * _Nonnull floor, CLLocationCoordinate2D centerPoint) {
        [self->successExpectation fulfill];
    };
    [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
    
    // 等待回调方法，10秒超时
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"route search test case over");
    }];

}

@end
