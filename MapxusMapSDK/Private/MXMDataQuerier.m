//
//  MXMDataQuerier.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/18.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMDataQuerier.h"
#import <YYModel/YYModel.h>
#import "MGLStyleLayer+MXMFilter.h"
#import "JXJsonFunctionDefine.h"
#import "MGLMapView+MXMSwizzle.h"
#import "MapxusMap+Private.h"

@interface MXMDataQuerier ()

@property (nonatomic, weak) MGLMapView *mapView;

@end

@implementation MXMDataQuerier

- (instancetype)initWithMapView:(MGLMapView *)mapView
{
    self = [super init];
    if (self) {
        self.mapView = mapView;
    }
    return self;
}


// 查找给定区域的所有建筑
- (NSDictionary *)findOutBuildingInTheRect:(CGRect)rect
{
    NSSet *identifiers = [self getBuildingLayerIdentifiersInLayers:self.mapView.style.layers];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:identifiers predicate:nil];
    NSDictionary *buildings = [self buildingDeduplicationInFeatures:theFeatures];
    return buildings;
}

// 查找给定区域的所有场所
- (NSDictionary *)findOutVenueInTheRect:(CGRect)rect
{
    NSSet *identifiers = [self getVenueLayerIdentifiersInLayers:self.mapView.style.layers];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:identifiers predicate:nil];
    NSDictionary *venues = [self venueDeduplicationInFeatures:theFeatures];
    return venues;
}

// 查找给定点的所有建筑
- (NSDictionary *)findOutBuildingAtPoint:(CGPoint)point
{
    NSSet *identifiers = [self getBuildingLayerIdentifiersInLayers:self.mapView.style.layers];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers];
    NSDictionary *buildings = [self buildingDeduplicationInFeatures:theFeatures];
    return buildings;
}

- (NSSet *)getVenueLayerIdentifiersInLayers:(NSArray<MGLStyleLayer *> *)layers
{
    NSMutableSet *identifiersSet = [NSMutableSet set];
    for (MGLStyleLayer *theLayer in layers) {
        if ([theLayer isVenueFillLayer]) {
            [identifiersSet addObject:theLayer.identifier];
        }
    }
    return [identifiersSet copy];
}

- (NSSet *)getBuildingLayerIdentifiersInLayers:(NSArray<MGLStyleLayer *> *)layers
{
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 筛选出『mapxus-building』开头的layer
    for (MGLStyleLayer *theLayer in layers) {
        if ([theLayer isBuildingFillLayer]) {
            [identifiersSet addObject:theLayer.identifier];
        }
    }
    
    return [identifiersSet copy];
}

- (NSDictionary *)buildingDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features
{
    // 建筑信息去重
    NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in features) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            MXMGeoBuilding *b = [MXMGeoBuilding yy_modelWithJSON:feature.attributes];
            NSDictionary *venue = self.mapView.mxmMap.venues[b.venueId];
            b.building = venue[@"venue"];
            [resultBuildings setObject:b forKey:theId];
        }
    }
    
    return [resultBuildings copy];
}

- (NSDictionary *)venueDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features
{
    // 建筑信息去重
    NSMutableDictionary *resultVenues = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in features) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            [resultVenues setObject:feature.attributes forKey:theId];
        }
    }
    
    return [resultVenues copy];
}



- (NSDictionary *)findOutPOIAtPoint:(CGPoint)point
{
    NSSet *identifiers = [self getIndoorSymbolLayerIdentifiersInLayers:self.mapView.style.layers];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers predicate:nil];
    NSDictionary *pois = [self poiDeduplicationInFeatures:theFeatures];
    return pois;
}

- (NSSet *)getIndoorSymbolLayerIdentifiersInLayers:(NSArray<MGLStyleLayer *> *)layers
{
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 筛选出『maphive-building-fill』开头的layer
    for (MGLStyleLayer *theLayer in layers) {
        if ([theLayer isIndoorSymbolLayer]) {
            [identifiersSet addObject:theLayer.identifier];
        }
    }
    
    return [identifiersSet copy];
}

- (NSDictionary *)poiDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features
{
    // 建筑信息去重
    NSMutableDictionary *resultPOIs = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in features) {
        NSString *theId = [feature attributeForKey:@"osm:ref"];
        if (theId) {
            // 解析POI经纬度
            NSDictionary *geoDic = feature.geoJSONDictionary;
            NSDictionary *geometry = DecodeDicFromDic(geoDic, @"geometry");
            NSArray *coordList = DecodeArrayFromDic(geometry, @"coordinates");
            NSNumber *lon = coordList.firstObject;
            NSNumber *lat = coordList.lastObject;
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
                        
            MXMGeoPOI *poi = [MXMGeoPOI yy_modelWithJSON:feature.attributes];
            poi.coordinate = coord;

            [resultPOIs setObject:poi forKey:theId];
        }
    }
    
    return [resultPOIs copy];
}

- (NSArray<id <MGLFeature>> *)findOutFloorFeaturesAtPoint:(CGPoint)point
{
    NSSet *identifiers = [[NSSet alloc] initWithObjects:@"mapxus-level-fill", nil];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers predicate:nil];
    return theFeatures;
}

@end
