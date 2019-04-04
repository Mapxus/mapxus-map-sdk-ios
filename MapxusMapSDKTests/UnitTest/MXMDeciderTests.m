//
//  MXMDeciderTests.m
//  MapxusMapSDKTests
//
//  Created by Chenghao Guo on 2019/3/26.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MXMDecider.h"
#import "MXMCommonObj.h"
#import "MXMGeoBuilding.h"
#import "CLFloorCategory/CLFloor+Factory.h"

@interface MXMDecider (UnitTest)

- (BOOL)shouldChangeWithList:(NSArray *)buildings currentBuildingId:(NSString *)curBuilding;

- (NSString *)calculateFloorWithLevel:(NSInteger)level andBuilding:(MXMGeoBuilding *)building;

- (BOOL)shouldBeQueryWithBuilding:(nullable MXMGeoBuilding *)building shouldZoomTo:(BOOL)zoomTo;

- (MXMGeoBuilding *)exchangeFrom:(MXMBuilding *)netBuilding;

- (nullable MXMGeoBuilding *)electDefaultBuildingRecentlyWithHistory:(NSArray<NSString *> *)historyList inBuildings:(NSArray<MXMGeoBuilding *> *)buildings;

- (nullable NSString *)electDefaultFloorWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building;

- (BOOL)canGoOnFilterWithBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor currentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andMapReload:(BOOL)isMapReload;

- (float)decideLocationViewAlphaWithCurrentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andLocalFloor:(nullable CLFloor *)floor;

@end


@interface MXMDeciderTests : XCTestCase

@property (nonatomic, strong) MXMDecider *decider;

@end

@implementation MXMDeciderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.decider = [[MXMDecider alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (MXMGeoBuilding *)createBuildingWithId:(NSString *)buildingId
{
    MXMGeoBuilding *building = [[MXMGeoBuilding alloc] init];
    building.identifier = buildingId;
    return building;
}

- (void)testShouldChange {
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:[self createBuildingWithId:@"sssss"]];
    [list addObject:[self createBuildingWithId:@"def"]];
    [list addObject:[self createBuildingWithId:@"rrr"]];
    [list addObject:[self createBuildingWithId:@"ewww"]];
    [list addObject:[self createBuildingWithId:@"fef"]];

    BOOL should1 = [self.decider shouldChangeWithList:list currentBuildingId:@"sssss"];
    XCTAssertFalse(should1, @"### list has 'sssss' should not be change ");

    BOOL should2 = [self.decider shouldChangeWithList:list currentBuildingId:@"dfdf"];
    XCTAssertTrue(should2, @"### list has 'sssss' should be change ");
}

- (void)testCalculateFloorWithLevel
{
    MXMGeoBuilding *geo = [[MXMGeoBuilding alloc] init];
    geo.ground_floor = @"G";
    geo.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    
    NSString *g = [self.decider calculateFloorWithLevel:0 andBuilding:geo];
    XCTAssertEqual(g, @"G", "should return G");
    
    NSString *f = [self.decider calculateFloorWithLevel:3 andBuilding:geo];
    XCTAssertEqual(f, @"L3", "should return L3");
    
    NSString *ug = [self.decider calculateFloorWithLevel:-2 andBuilding:geo];
    XCTAssertEqual(ug, @"UG2", "should return UG2");
}

- (void)testShouldBeQueryWithBuilding
{
    MXMGeoBuilding *g = [[MXMGeoBuilding alloc] init];
    BOOL s1 = [self.decider shouldBeQueryWithBuilding:g shouldZoomTo:YES];
    XCTAssertTrue(s1, "should be query");
    
    BOOL s2 = [self.decider shouldBeQueryWithBuilding:g shouldZoomTo:NO];
    XCTAssertFalse(s2, "should not be query");
    
    BOOL s3 = [self.decider shouldBeQueryWithBuilding:nil shouldZoomTo:YES];
    XCTAssertTrue(s3, "should be query");

    BOOL s4 = [self.decider shouldBeQueryWithBuilding:nil shouldZoomTo:NO];
    XCTAssertTrue(s4, "should be query");

}


- (void)testExchange
{
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:[self createFloor:@"L1"]];
    [list addObject:[self createFloor:@"L2"]];
    [list addObject:[self createFloor:@"L3"]];
    [list addObject:[self createFloor:@"L4"]];
    
    MXMBuilding *b = [[MXMBuilding alloc] init];
    b.buildingId = @"sss";
    b.name_default = @"rere";
    b.name_en = @"wwwf";
    b.name_cn = @"ffwe";
    b.name_zh = @"afd";
    b.type = @"ere";
    b.floors = [list copy];
    
    MXMGeoBuilding *geo = [self.decider exchangeFrom:b];
    XCTAssertEqual(geo.identifier, b.buildingId, @"id worng");
    XCTAssertEqual(geo.building, b.type, @"type worng");
    XCTAssertEqual(geo.name, b.name_default, @"name worng");
    XCTAssertEqual(geo.name_en, b.name_en, @"name_en worng");
    XCTAssertEqual(geo.name_cn, b.name_cn, @"name_cn worng");
    XCTAssertEqual(geo.name_zh, b.name_zh, @"name_zh worng");
    
    MXMFloor *bLast = b.floors.lastObject;
    XCTAssertEqual(geo.floors.firstObject, bLast.code, @"floor worng");
}

- (MXMFloor *)createFloor:(NSString *)floor
{
    MXMFloor *f1 = [[MXMFloor alloc] init];
    f1.code = floor;
    return f1;
}

- (void)testElectDefaultBuildingRecentlyWithHistory
{
    NSArray *history = @[@"lls", @"lop", @"iio"];
    
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:[self createBuildingWithId:@"asdf"]];
    [list addObject:[self createBuildingWithId:@"werwef"]];
    [list addObject:[self createBuildingWithId:@"lls"]];
    [list addObject:[self createBuildingWithId:@"erel"]];
    [list addObject:[self createBuildingWithId:@"wwf"]];

    MXMGeoBuilding *b = [self.decider electDefaultBuildingRecentlyWithHistory:history inBuildings:list];
    XCTAssertEqual(b.identifier, @"lls", @"should choose lls");
    
    NSMutableArray *list2 = [NSMutableArray array];
    [list2 addObject:[self createBuildingWithId:@"asdf"]];
    [list2 addObject:[self createBuildingWithId:@"werwef"]];
    [list2 addObject:[self createBuildingWithId:@"sdfsd"]];
    [list2 addObject:[self createBuildingWithId:@"erel"]];
    [list2 addObject:[self createBuildingWithId:@"wwf"]];
    
    MXMGeoBuilding *b2 = [self.decider electDefaultBuildingRecentlyWithHistory:history inBuildings:list2];
    XCTAssertEqual(b2.identifier, @"asdf", @"should choose asdf");
}

- (void)testElectDefaultFloorWithHistory
{
    NSDictionary *history = @{@"sfdf": @"L1", @"ssss": @"G"};
    
    MXMGeoBuilding *geo = [[MXMGeoBuilding alloc] init];
    geo.identifier = @"sfdf";
    geo.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    geo.ground_floor = @"G";
    
    NSString *f1 = [self.decider electDefaultFloorWithHistory:history inBuilding:geo];
    XCTAssertEqual(f1, @"L1", @"should choose L1");

    MXMGeoBuilding *geo2 = [[MXMGeoBuilding alloc] init];
    geo2.identifier = @"ssffdf";
    geo2.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    geo2.ground_floor = @"G";
    
    NSString *f2 = [self.decider electDefaultFloorWithHistory:history inBuilding:geo2];
    XCTAssertEqual(f2, @"G", @"should choose G");
}

- (void)testCanGoOnFilterWithBuilding
{
    BOOL canGo = [self.decider canGoOnFilterWithBuilding:nil floor:nil currentBuilding:nil currentFloor:nil andMapReload:YES];
    XCTAssertFalse(canGo, "should not be go on");

    
    MXMGeoBuilding *geo = [[MXMGeoBuilding alloc] init];
    geo.identifier = @"sfdf";
    geo.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    geo.ground_floor = @"G";
    
    MXMGeoBuilding *curGeo = [[MXMGeoBuilding alloc] init];
    curGeo.identifier = @"current";
    curGeo.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    curGeo.ground_floor = @"G";
    
    BOOL canGo1 = [self.decider canGoOnFilterWithBuilding:geo floor:@"L2" currentBuilding:curGeo currentFloor:@"L3" andMapReload:NO];
    XCTAssertTrue(canGo1, "should be go on");

    BOOL canGo2 = [self.decider canGoOnFilterWithBuilding:geo floor:@"L2" currentBuilding:geo currentFloor:@"L2" andMapReload:NO];
    XCTAssertFalse(canGo2, "should not be go on");
    
    BOOL canGo3 = [self.decider canGoOnFilterWithBuilding:geo floor:@"L2" currentBuilding:geo currentFloor:@"L2" andMapReload:YES];
    XCTAssertTrue(canGo3, "should be go on");

    BOOL canGo4 = [self.decider canGoOnFilterWithBuilding:geo floor:@"L2" currentBuilding:curGeo currentFloor:@"L2" andMapReload:NO];
    XCTAssertTrue(canGo4, "should be go on");

    BOOL canGo5 = [self.decider canGoOnFilterWithBuilding:geo floor:@"L4" currentBuilding:curGeo currentFloor:@"L2" andMapReload:NO];
    XCTAssertFalse(canGo5, "should not be go on");
}

- (void)testDecideLocationViewAlphaWithCurrentBuilding
{
    MXMGeoBuilding *geo = [[MXMGeoBuilding alloc] init];
    geo.identifier = @"sfdf";
    geo.floors = @[@"L3", @"L2", @"L1", @"G", @"UG1", @"UG2"];
    geo.ground_floor = @"G";
    
    float alpha = [self.decider decideLocationViewAlphaWithCurrentBuilding:geo currentFloor:@"L3" andLocalFloor:nil];
    XCTAssertTrue(alpha == 1.0, @"alpha should be 1.0");
    
    CLFloor *f = [CLFloor createFloorWihtLevel:2];
    float alpha2 = [self.decider decideLocationViewAlphaWithCurrentBuilding:geo currentFloor:@"L3" andLocalFloor:f];
    XCTAssertTrue(alpha2 == 0.5, @"alpha should be 0.5");
    
    CLFloor *f2 = [CLFloor createFloorWihtLevel:3];
    float alpha3 = [self.decider decideLocationViewAlphaWithCurrentBuilding:geo currentFloor:@"L3" andLocalFloor:f2];
    XCTAssertTrue(alpha3 == 1.0, @"alpha should be 1.0");
}

@end
