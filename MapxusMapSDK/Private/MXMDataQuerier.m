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
#import "MGLPolygon+MXMFuction.h"

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


- (NSDictionary *)findOutPOIOnLevelIds:(NSArray *)levelIds
{
  MGLSource *source = [self.mapView.style sourceWithIdentifier:@"indoor-planet"];
  if (!source || ![source isKindOfClass:[MGLVectorTileSource class]]) {
    return @{};
  }
  MGLVectorTileSource *vSource = (MGLVectorTileSource *)source;
  
  NSPredicate *p1 = [NSPredicate predicateWithFormat:@"%K IN %@", @"ref:level", levelIds];
  NSPredicate *p2 = [NSPredicate predicateWithFormat:@"type == Point"];
  NSCompoundPredicate *pp = [NSCompoundPredicate andPredicateWithSubpredicates:@[p2, p1]];
  
  NSArray<id <MGLFeature>> *theFeatures = [vSource featuresInSourceLayersWithIdentifiers:[NSSet setWithObject:@"mapxus_place"]
                                                                               predicate:pp];
  NSDictionary *pois = [self poiDeduplicationInFeatures:theFeatures];
  return pois;
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
                                          pointCoordinate:(CLLocationCoordinate2D)coordinate
{
  // 分开两个获取队列是为了让点击重叠楼层时先获取上层的对象
  NSArray<id <MGLFeature>> *theForeFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:[NSSet setWithObject:@"mapxus-level-fill"] predicate:nil];
  NSArray<id <MGLFeature>> *theRearFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:[NSSet setWithObject:@"mapxus-level-fill-mxmrear"] predicate:nil];
  NSMutableArray<id <MGLFeature>> *mutFeatures = [NSMutableArray arrayWithArray:theForeFeatures];
  [mutFeatures addObjectsFromArray:theRearFeatures];
  NSArray *theFeatures = [mutFeatures copy];
  if (theFeatures.count > 1) {
    theFeatures = [self removePolygonByPointingAtHole:coordinate inPolygons:theFeatures];
  }
  // 为了让点击重叠楼层时先获取上层的对象，不能使用字典去重
  NSMutableArray *list = [NSMutableArray array];
  for (id <MGLFeature> feature in theFeatures) {
    MXMLevelModel *model = [MXMLevelModel yy_modelWithJSON:feature.attributes];
    if (model) {
      [list addObject:model];
    }
  }
  return [list copy];
}

- (NSArray<MXMLevelModel *> *)findOutAssistantFloorFeaturesAtPoint:(CGPoint)point
                                                   pointCoordinate:(CLLocationCoordinate2D)coordinate
{
  NSSet *identifiers = [NSSet setWithObject:@"assistant-mapxus-level-fill"];
  NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiers predicate:nil];
  if (theFeatures.count > 1) {
    theFeatures = [self removePolygonByPointingAtHole:coordinate inPolygons:theFeatures];
  }
  NSDictionary *dic = [self floorDeduplicationInFeatures:theFeatures];
  return [dic allValues];
}

- (NSArray<id <MGLFeature>> *)removePolygonByPointingAtHole:(CLLocationCoordinate2D)point inPolygons:(NSArray<id <MGLFeature>> *)polygons {
  NSMutableArray *list = [NSMutableArray array];
  
  for (id <MGLFeature> feature in polygons) {
    
    if ([feature isKindOfClass:[MGLPolygon class]]) {
      MGLPolygon *polygon = (MGLPolygon *)feature;
      if ([self polygon:polygon containsPoint:point]) {
        [list addObject:feature];
      }
    }
    
    else if ([feature isKindOfClass:[MGLMultiPolygon class]]) {
      MGLMultiPolygon *multiPolygon = (MGLMultiPolygon *)feature;
      BOOL inMultiPolygon = NO;
      for (MGLPolygon *polygon in multiPolygon.polygons) {
        if ([self polygon:polygon containsPoint:point]) {
          inMultiPolygon = YES;
          break;
        }
      }
      if (inMultiPolygon) {
        [list addObject:feature];
      }
    }
    
  }
  return [list copy];
}

- (BOOL)polygon:(MGLPolygon *)polygon containsPoint:(CLLocationCoordinate2D)point {
  BOOL inOuter = [polygon contains:point ignoreBoundary:NO];
  BOOL inInner = NO;
  for (MGLPolygon *p in polygon.interiorPolygons) {
    if ([p contains:point ignoreBoundary:YES]) {
      inInner = YES;
      break;
    }
  }
  return inOuter && !inInner;
}


@end
