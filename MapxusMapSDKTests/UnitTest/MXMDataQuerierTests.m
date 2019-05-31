//
//  MXMDataQuerierTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/3/26.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MXMDataQuerier.h"

@interface MXMDataQuerier (UnitTest)
- (NSSet *)getBuildingLayerIdentifiersInLayers:(NSArray<MGLStyleLayer *> *)layers;
- (NSDictionary *)buildingDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features;
- (NSSet *)getIndoorSymbolLayerIdentifiersInLayers:(NSArray<MGLStyleLayer *> *)layers;
- (NSDictionary *)poiDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features;

@end

@interface MXMDataQuerierTests : XCTestCase

@end

@implementation MXMDataQuerierTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


@end
