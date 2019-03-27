//
//  MXMAnnotationsHolderTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/3/26.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MXMAnnotationsHolder.h"

@interface MXMAnnotationsHolder (UnitTest)

- (BOOL)decideShouldBeHiddenWithAnnotation:(MXMPointAnnotation *)ann Building:(NSString *)buildingId floor:(NSString *)floor indoorState:(BOOL)isIndoor;

@end

@interface MXMAnnotationsHolderTests : XCTestCase

@property (nonatomic, strong) MXMAnnotationsHolder *holder;

@end

@implementation MXMAnnotationsHolderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    MGLMapView *mapView = OCMClassMock([MGLMapView class]);
    self.holder = [[MXMAnnotationsHolder alloc] initWithMapView:mapView];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAnnotationHidden {
    MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
    ann.buildingId = @"buildingId";
    ann.floor = @"floor";

    BOOL hidden = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:nil floor:nil indoorState:NO];
    XCTAssertFalse(hidden, @"### 'testAnnotationHidden error");

    BOOL hidden2 = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:@"ssss" floor:@"floor" indoorState:NO];
    XCTAssertFalse(hidden2, @"### 'testAnnotationHidden error");

    BOOL hidden3 = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:@"buildingId" floor:@"floor" indoorState:NO];
    XCTAssertFalse(hidden3, @"### 'testAnnotationHidden error");

    
    
    BOOL hidden4 = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:@"buildingId" floor:@"xxx" indoorState:YES];
    XCTAssertTrue(hidden4, @"### 'testAnnotationHidden error");

    BOOL hidden5 = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:@"ssss" floor:@"floor" indoorState:YES];
    XCTAssertFalse(hidden5, @"### 'testAnnotationHidden error");

    BOOL hidden6 = [self.holder decideShouldBeHiddenWithAnnotation:ann Building:@"buildingId" floor:@"floor" indoorState:YES];
    XCTAssertFalse(hidden6, @"### 'testAnnotationHidden error");

    

    MXMPointAnnotation *ann2 = [[MXMPointAnnotation alloc] init];

    BOOL hidden7 = [self.holder decideShouldBeHiddenWithAnnotation:ann2 Building:@"buildingId" floor:@"floor" indoorState:NO];
    XCTAssertFalse(hidden7, @"### 'testAnnotationHidden error");

    BOOL hidden8 = [self.holder decideShouldBeHiddenWithAnnotation:ann2 Building:@"buildingId" floor:@"floor" indoorState:YES];
    XCTAssertFalse(hidden8, @"### 'testAnnotationHidden error");

}


@end
