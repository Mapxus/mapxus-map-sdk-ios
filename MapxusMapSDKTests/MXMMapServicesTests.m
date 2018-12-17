//
//  MXMMapServicesTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2018/12/12.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MXMMapServices+Private.h"

@interface MXMMapServicesTests : XCTestCase

@end

@implementation MXMMapServicesTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGetToken {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    __block NSString *blockToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"getToken"];

    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        blockToken = token;
        [expectation fulfill];
    }];
    
    // 等待回调方法，30秒超时
    [self waitForExpectationsWithTimeout:10 handler:nil];
    XCTAssertNotNil(blockToken);
}

// token过期测试
- (void)testOvertime {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *overtimeToken = @"eyJraWQiOiJlWXphSk9qRDQzcHdQQ2F1cHpmdFF3WFhDdlpJeDRhbWdiVnQ5ZHBTUmdRPSIsImFsZyI6IlJTMjU2In0.eyJjdXN0b206YnVuZGxlSWQiOiJjb20ubWFweHVzLlNES0V4YW1wbGUiLCJzdWIiOiI4MDBlNDhkNi1lY2Y2LTRlOTUtYjBjNi1hZTRkNTVkMGZlMzgiLCJhdWQiOiI2Mmdpcjg1Z2FrZzJxdWU0bzgwb21kcmUxaiIsImN1c3RvbTpwbGF0Zm9ybSI6IklPUyIsImV2ZW50X2lkIjoiYTE3YWMwN2EtZmVhNy0xMWU4LWFlMDYtMjMxNjVlZWQyZjNhIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE1NDQ2ODU2NTUsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMS5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMV9SUFZCR2JvTEwiLCJjb2duaXRvOnVzZXJuYW1lIjoiY29tLm1hcHh1c21hcC51bml0dGVzdC5pb3MiLCJleHAiOjE1NDQ2ODkyNTUsImlhdCI6MTU0NDY4NTY1NX0.MYMdYPxnVMIpPmGUiVfDu_8yS2LiNuslh39wL7WhAFkxD_dIcORUmUgGk4PG-TzvSbDtRDum9IUg-YSDY5H4UwVu3jYhGt5Zf4nYGnGNMwxm6sPOjbYdlaFfYVJ04gGQtu7DmJc-Uw_Ot4sDd-a62hdCQpi7JhcjiHyC-SGrpVDdGrkZOrIGm2M8RRl_2fnukfRO8RbAKKf2tcmOGzVjAR4lJkhYq1wfQ3VF7RqUIl5hVVm2tLT0bE7sXV1BFwpVIYkXAtnJmbe5qTcvQP52TW5OESM3Twg7Eu3kAfKfaLCj3Zt_KhzhPjhTW43vLk6lY6nCMuoErECDU9Uriars2A";
    [[NSUserDefaults standardUserDefaults] setObject:overtimeToken forKey:@"MXMToken"];

    __block NSString *blockToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"getToken"];
    
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        blockToken = token;
        [expectation fulfill];
    }];
    
    // 等待回调方法，30秒超时
    [self waitForExpectationsWithTimeout:10 handler:nil];
    XCTAssertNotNil(blockToken);
    XCTAssertFalse([overtimeToken isEqualToString:blockToken], @"can not get the new token");
}


//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
