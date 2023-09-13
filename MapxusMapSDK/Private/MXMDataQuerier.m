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

- (NSDictionary *)findOutFloorInTheRect:(CGRect)rect {
  NSSet *identifiers = [NSSet setWithObject:@"assistant-mapxus-level-fill"];
  NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:identifiers predicate:nil];
  return [self floorDeduplicationInFeatures:theFeatures];
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
  for (MGLStyleLayer *theLayer in layers) {
    if ([theLayer isBuildingFillLayer]) {
      [identifiersSet addObject:theLayer.identifier];
    }
  }
  
  return [identifiersSet copy];
}

- (NSDictionary *)floorDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features
{
  // 建筑信息去重
  NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
  for (id <MGLFeature> feature in features) {
    NSString *theId = [feature attributeForKey:@"id"];
    if (theId) {
      MXMLevelModel *model = [MXMLevelModel yy_modelWithJSON:feature.attributes];
      resultBuildings[theId] = model;
    }
  }
  
  return [resultBuildings copy];
}

- (NSDictionary *)buildingDeduplicationInFeatures:(NSArray<id <MGLFeature>> *)features
{
  // 建筑信息去重
  NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
  for (id <MGLFeature> feature in features) {
    NSString *theId = [feature attributeForKey:@"id"];
    if (theId) {
      MXMGeoBuilding *b = [MXMGeoBuilding yy_modelWithJSON:feature.attributes];
      MXMGeoVenue *venue = self.mapView.mxmMap.decider.visibleVenues[b.venueId];
      b.category = venue.category; //building的类型放到了venue上，需要从venue里拿
      if ([feature isKindOfClass:[MGLPolygonFeature class]]) {
        MGLPolygonFeature *polygon = (MGLPolygonFeature *)feature;
        b.bbox = [MXMBoundingBox boundingBoxWithMinLatitude:polygon.overlayBounds.sw.latitude
                                               minLongitude:polygon.overlayBounds.sw.longitude
                                                maxLatitude:polygon.overlayBounds.ne.latitude
                                               maxLongitude:polygon.overlayBounds.ne.longitude];
      }
      resultBuildings[theId] = b;
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
      MXMGeoVenue *venue = [MXMGeoVenue yy_modelWithJSON:feature.attributes];
      if ([feature isKindOfClass:[MGLPolygonFeature class]]) {
        MGLPolygonFeature *polygon = (MGLPolygonFeature *)feature;
        venue.bbox = [MXMBoundingBox boundingBoxWithMinLatitude:polygon.overlayBounds.sw.latitude
                                                   minLongitude:polygon.overlayBounds.sw.longitude
                                                    maxLatitude:polygon.overlayBounds.ne.latitude
                                                   maxLongitude:polygon.overlayBounds.ne.longitude];
      }
      resultVenues[theId] = venue;
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
      
      resultPOIs[theId] = poi;
    }
  }
  
  return [resultPOIs copy];
}

- (NSArray<MXMLevelModel *> *)findOutFloorFeaturesAtPoint:(CGPoint)point
{
  NSSet *identifiers = [NSSet setWithObjects:@"mapxus-level-fill", @"mapxus-level-fill-mxmrear", nil];
  NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers predicate:nil];
  NSMutableArray *list = [NSMutableArray array];
  for (id <MGLFeature> feature in theFeatures) {
    MXMLevelModel *model = [MXMLevelModel yy_modelWithJSON:feature.attributes];
    if (model) {
      [list addObject:model];
    }
  }
  return list;
}

- (NSArray<MXMLevelModel *> *)findOutAssistantFloorFeaturesAtPoint:(CGPoint)point
{
  NSSet *identifiers = [NSSet setWithObject:@"assistant-mapxus-level-fill"];
  NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers predicate:nil];
  NSMutableArray *list = [NSMutableArray array];
  for (id <MGLFeature> feature in theFeatures) {
    MXMLevelModel *model = [MXMLevelModel yy_modelWithJSON:feature.attributes];
    if (model) {
      [list addObject:model];
    }
  }
  return list;
}

@end
