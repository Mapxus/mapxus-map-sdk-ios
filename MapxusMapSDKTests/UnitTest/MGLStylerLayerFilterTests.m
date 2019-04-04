//
//  MGLStylerLayerFilterTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/3/25.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MGLStyleLayer+MXMFilter.h"
#import <OCMock/OCMock.h>

@interface MGLStylerLayerFilterTests : XCTestCase

@end

@implementation MGLStylerLayerFilterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (MGLStyleLayer *)createBuildingFillLayerWithIdentifier:(NSString *)identifier
{
    MGLSource *s = [[MGLSource alloc] initWithIdentifier:@"dd"];
    MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:identifier source:s];
    return layer;
}

- (void)testIsBuildingFillLayer {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    MGLStyleLayer *layer = [self createBuildingFillLayerWithIdentifier:@"maphive-building-fill"];
    XCTAssertTrue([layer isBuildingFillLayer], @"### 'maphive-building-fill' should be true");
    
    MGLStyleLayer *layer2 = [self createBuildingFillLayerWithIdentifier:@"maphive-building-fill-xxx"];
    XCTAssertTrue([layer2 isBuildingFillLayer], @"### 'maphive-building-fill-xxx' should be true");
    
    MGLStyleLayer *layer3 = [self createBuildingFillLayerWithIdentifier:@"maphive-building"];
    XCTAssertFalse([layer3 isBuildingFillLayer], @"### 'maphive-building' should be false");
}

- (void)testIsIndoorSymbolLayer {
    
    MGLVectorStyleLayer *vectorLayer = OCMClassMock([MGLVectorStyleLayer class]);
    XCTAssertFalse([vectorLayer isIndoorSymbolLayer], @"### MGLVectorStyleLayer is not indoor layer");

    MGLStyleLayer *layer2 = [self createBuildingFillLayerWithIdentifier:@"building-fill-xxx"];
    XCTAssertFalse([layer2 isBuildingFillLayer], @"### 'building-fill-xxx' is not indoor layer");
    
    MGLStyleLayer *layer3 = [self createBuildingFillLayerWithIdentifier:@"maphive-building"];
    XCTAssertTrue([layer3 isIndoorSymbolLayer], @"### 'maphive-building' MGLSymbolStyleLayer should be true");
}

- (void)testIsOutdoorLayer {
    MGLSource *s = [[MGLSource alloc] initWithIdentifier:@"composite"];
    MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"xxx" source:s];
    XCTAssertTrue([layer isOutdoorLayer], @"### composite source is outdoor layer");
    
    MGLBackgroundStyleLayer *backgroundLayer = OCMClassMock([MGLBackgroundStyleLayer class]);
    XCTAssertFalse([backgroundLayer isOutdoorLayer], @"### MGLBackgroundStyleLayer is not outdoor layer");
}


@end
