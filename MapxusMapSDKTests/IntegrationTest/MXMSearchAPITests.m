//
//  MXMSearchAPITests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2018/12/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapxusMapSDK.h"

XCTestExpectation *networkSuccessExpectation;

@interface MXMSearchAPITests : XCTestCase <MXMSearchDelegate>

@end

@implementation MXMSearchAPITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRouteSearchFunction {
    networkSuccessExpectation = [self expectationWithDescription:@"testRouteSearchFunction"];
    
    MXMRouteSearchRequest *re = [[MXMRouteSearchRequest alloc] init];
    re.fromBuilding = @"harbourcity_hk_8b580b";
    re.fromFloor = @"L2";
    re.fromLat = 22.298420346749509;
    re.fromLon = 114.16835642455044;
    re.toBuilding = @"harbourcity_hk_8b580b";
    re.toFloor = @"L3";
    re.toLat = 22.297405794928551;
    re.toLon = 114.1680489021503;
    re.locale = @"zh-cn";
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMRouteSearch:re];
    
    // 等待回调方法，10秒超时
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"route search test case over");
    }];
}

- (void)testPOICategorySearchFunction {
    networkSuccessExpectation = [self expectationWithDescription:@"testPOICategorySearchFunction"];
    
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = 22.304716516178253;
    point.longitude = 114.16186609400843;
    
    MXMPOICategorySearchRequest *re = [[MXMPOICategorySearchRequest alloc] init];
    re.buildingId = @"elements_hk_dc005f";
    re.floor = @"L1";
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOICategorySearch:re];
    
    // 等待回调方法，10秒超时
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"route search test case over");
    }];
}


- (void)testPOISearchFunction {
    networkSuccessExpectation = [self expectationWithDescription:@"testPOISearchFunction"];
    
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = 22.304716516178253;
    point.longitude = 114.16186609400843;
    
    MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
    re.keywords = @"sa";
    re.center = point;
    re.meterDistance = 107;
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOISearch:re];
    
    // 等待回调方法，10秒超时
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"route search test case over");
    }];
}

- (void)testBuildingSearchFunction {
    networkSuccessExpectation = [self expectationWithDescription:@"testBuildingSearchFunction"];
    
    MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
    re.keywords = @"vivo";
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMBuildingSearch:re];
    
    // 等待回调方法，10秒超时
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"route search test case over");
    }];
}


- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if ([request isKindOfClass:[MXMRouteSearchRequest class]]) {
        XCTAssertNil(error, @"route search error : %@", error);
    } else if ([request isKindOfClass:[MXMPOISearchRequest class]]) {
        XCTAssertNil(error, @"poi search error : %@", error);
    } else if ([request isKindOfClass:[MXMBuildingSearchRequest class]]) {
        XCTAssertNil(error, @"building search error : %@", error);
    }
    // 触发fulfill方法，跳出单测程序等待状态
    [networkSuccessExpectation fulfill];
}

- (void)onPOICategorySearchDone:(MXMPOICategorySearchRequest *)request response:(MXMPOICategorySearchResponse *)response
{
    XCTAssertNotNil(response, @"poi category search error");
    // 触发fulfill方法，跳出单测程序等待状态
    [networkSuccessExpectation fulfill];
}

- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response
{
    XCTAssertNotNil(response, @"poi search error");
    // 触发fulfill方法，跳出单测程序等待状态
    [networkSuccessExpectation fulfill];
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response
{
    XCTAssertNotNil(response, @"building search error");
    // 触发fulfill方法，跳出单测程序等待状态
    [networkSuccessExpectation fulfill];
}

- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response
{
    XCTAssertNotNil(response, @"route search error");
    // 触发fulfill方法，跳出单测程序等待状态
    [networkSuccessExpectation fulfill];
}


@end
