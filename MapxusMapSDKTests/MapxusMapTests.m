//
//  MapxusMapTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2018/12/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapxusMapSDK.h"
#import <Mapbox/Mapbox.h>


@interface MapxusMapTests : XCTestCase <MGLMapViewDelegate, MapxusMapDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *indoorMap;
@property (nonatomic, strong) XCTestExpectation *testLoadStyleExpectation;
//@property (nonatomic, strong) XCTestExpectation *testLoadBuildingExpectation;
//@property (nonatomic, strong) XCTestExpectation *testLoadPOIExpectation;

@end

@implementation MapxusMapTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLoadStyle {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    self.testLoadStyleExpectation = [self expectationWithDescription:@"testLoadStyle"];

    self.mapView = [[MGLMapView alloc] init];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.mapView.delegate = self;
    
    self.indoorMap = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.indoorMap.delegate = self;
    
    [self waitForExpectationsWithTimeout:20 handler:nil];

}

//- (void)testLoadWihtBuilding
//{
//    self.testLoadBuildingExpectation = [self expectationWithDescription:@"testLoadWihtBuilding"];
//
//    self.mapView = [[MGLMapView alloc] init];
//
//    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
//    configuration.buildingId = @"pacificplace_hk_4d1f10";
//    configuration.floor = @"L3";
//
//    self.indoorMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
//
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//}
//
//- (void)testLoadWithPOI
//{
//    self.testLoadPOIExpectation = [self expectationWithDescription:@"testLoadWithPOI"];
//
//    self.mapView = [[MGLMapView alloc] init];
//
//    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
//    configuration.poiId = @"75656";
//
//    self.indoorMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
//
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//
//}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style
{
    XCTAssertNotNil(style);
    [self.testLoadStyleExpectation fulfill];
}

//- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building
//{
//
//}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
