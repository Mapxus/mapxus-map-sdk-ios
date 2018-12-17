//
//  MXMHttpManagerTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2018/12/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MXMHttpManager.h"
#import "MXMConstants.h"

@interface MXMHttpManagerTests : XCTestCase

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation MXMHttpManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// 我司地址加token和identifier
- (void)testPOST {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testPOST"];

    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v2/buildings"];
    self.task = [MXMHttpManager MXMPOST:url parameters:nil success:nil failure:^(NSError *error) {
        NSDictionary *header = self.task.currentRequest.allHTTPHeaderFields;
        XCTAssertNotNil(header[@"sdkVersion"]);
        XCTAssertNotNil(header[@"token"]);
        XCTAssertNotNil(header[@"identifier"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// 非我司地址不加token和identifier
- (void)testOtherURL {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testOtherURL"];
    
    NSString *url = @"https://www.baidu.com";
    self.task = [MXMHttpManager MXMPOST:url parameters:nil success:nil failure:^(NSError *error) {
        NSDictionary *header = self.task.currentRequest.allHTTPHeaderFields;
        XCTAssertNil(header[@"sdkVersion"]);
        XCTAssertNil(header[@"token"]);
        XCTAssertNil(header[@"identifier"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
