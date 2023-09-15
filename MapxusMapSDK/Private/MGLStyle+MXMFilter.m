//
//  MGLStyle+MXMFilter.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/11/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MGLStyle+MXMFilter.h"

@implementation MGLStyle (MXMFilter)

- (void)MXMlocalizeLabelsIntoLocale:(nullable NSString *)localeLanguage {
  NSArray *arr = self.layers;
  for (MGLStyleLayer *k in arr) {
    // 过滤不需要处理的layer
    if (![k isKindOfClass:[MGLSymbolStyleLayer class]]) {
      continue;
    }
    
    MGLSymbolStyleLayer *sk = (MGLSymbolStyleLayer *)k;
    
    if (sk.text.expressionType != NSConstantValueExpressionType) {
      if ([localeLanguage containsString:@"en"]) {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K})", @"name:en", @"name_en", @"_name", @"name"];
        
      } else if ([localeLanguage containsString:@"zh-Hant"]) {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K, %K, %K})", @"name:zh-Hant", @"name_zh", @"name:zh", @"name_zh-Hans", @"_name", @"name"];
        
      } else if ([localeLanguage containsString:@"zh-Hans"]) {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K, %K, %K})", @"name:zh-Hans", @"name_zh-Hans", @"name:cn", @"name_zh", @"_name", @"name"];
        
      } else if ([localeLanguage containsString:@"ja"]) {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K})", @"name:ja", @"_name", @"name"];
        
      } else if ([localeLanguage containsString:@"ko"]) {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K})", @"name:ko", @"_name", @"name"];
        
      } else {
        sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K})", @"_name", @"name"];
      }
    }
  }
}

- (void)updateSelectedBuildingFillOpacityWithIds:(NSArray<NSString *> *)buildingIds notIn:(BOOL)notIn {
  MGLStyleLayer *layer = [self layerWithIdentifier:@"mapxus-building-line"];
  if ([layer isKindOfClass:[MGLFillStyleLayer class]]) {
    MGLFillStyleLayer *buildingFill = (MGLFillStyleLayer *)layer;
    if (notIn) {
      buildingFill.fillOpacity = [NSExpression mgl_expressionForConditional:[NSPredicate predicateWithFormat:@"id IN %@", buildingIds]
                                                             trueExpression:[NSExpression expressionForConstantValue:@(1)]
                                                           falseExpresssion:[NSExpression expressionForConstantValue:@(0)]];
    } else {
      buildingFill.fillOpacity = [NSExpression mgl_expressionForConditional:[NSPredicate predicateWithFormat:@"id IN %@", buildingIds]
                                                             trueExpression:[NSExpression expressionForConstantValue:@(0)]
                                                           falseExpresssion:[NSExpression expressionForConstantValue:@(1)]];
    }
  }
  
  MGLStyleLayer *line_layer = [self layerWithIdentifier:@"mapxus-building-line-color"];
  line_layer.visible = NO;
}

- (void)unMaskBuildingFill {
  MGLStyleLayer *layer = [self layerWithIdentifier:@"mapxus-building-line"];
  if ([layer isKindOfClass:[MGLFillStyleLayer class]]) {
    MGLFillStyleLayer *buildingFill = (MGLFillStyleLayer *)layer;
    buildingFill.fillOpacity = [NSExpression expressionForConstantValue:@(0)];
  }
  
  MGLStyleLayer *line_layer = [self layerWithIdentifier:@"mapxus-building-line-color"];
  line_layer.visible = NO;
}

// 地图图层数据过滤，保证buildingId和floor不能为空
- (void)filerLevelIds:(NSArray *)levelIds {
  NSArray *arr = self.layers;
  for (MGLStyleLayer *k in arr) {
    // 过滤不需要处理的layer
    if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
      continue;
    }
    MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
    NSString *ident = vk.identifier;
    if (![ident hasPrefix:@"mapxus"] || [ident hasPrefix:@"mapxus-building"] || [vk.sourceLayerIdentifier hasPrefix:@"mapxus_venue"] || [ident hasSuffix:@"-mxmrear"] || [ident hasPrefix:@"mapxus-poi"]) {
      continue;
    }
    NSString *levelKey = @"ref:level";
    if ([vk.sourceLayerIdentifier hasPrefix:@"mapxus_level"]) {
      levelKey = @"id";
    }
    
    NSPredicate *pp = [NSPredicate predicateWithFormat:@"%K IN %@", levelKey, levelIds];
    // 处理剩下需要添加filter的layer
    id originalPredicate = vk.predicate;
    NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
    if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
      NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
      for (NSCompoundPredicate *s in sub) {
        NSString *str = s.predicateFormat;
        if (![str containsString:[NSString stringWithFormat:@"%@ IN", levelKey]]) {
          [mu addObject:s];
        }
      }
    } else {
      if (originalPredicate) {
        [mu addObject:originalPredicate];
      }
    }
    //        NSPredicate *f = [NSPredicate predicateWithFormat:@"%K == %@", levelKey, levelId];
    [mu addObject:pp];
    //        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
    //        [mu addObject:b];
    NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
    // 重置过滤
    vk.predicate = reSetPredicate;
  }
}

- (void)filerRearLevelIds:(NSArray *)levelIds {
  NSArray *arr = self.layers;
  for (MGLStyleLayer *k in arr) {
    // 过滤不需要处理的layer
    if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
      continue;
    }
    MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
    NSString *ident = vk.identifier;
    if (![ident hasPrefix:@"mapxus"] || [ident hasPrefix:@"mapxus-building"] || [vk.sourceLayerIdentifier hasPrefix:@"mapxus_venue"] || ![ident hasSuffix:@"-mxmrear"] || [ident hasPrefix:@"mapxus-poi"]) {
      continue;
    }
    NSString *levelKey = @"ref:level";
    if ([vk.sourceLayerIdentifier hasPrefix:@"mapxus_level"]) {
      levelKey = @"id";
    }
    
    NSPredicate *pp = [NSPredicate predicateWithFormat:@"%K IN %@", levelKey, levelIds];
    // 处理剩下需要添加filter的layer
    id originalPredicate = vk.predicate;
    NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
    if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
      NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
      for (NSCompoundPredicate *s in sub) {
        NSString *str = s.predicateFormat;
        if (![str containsString:[NSString stringWithFormat:@"%@ IN", levelKey]]) {
          [mu addObject:s];
        }
      }
    } else {
      if (originalPredicate) {
        [mu addObject:originalPredicate];
      }
    }
    //        NSPredicate *f = [NSPredicate predicateWithFormat:@"%K == %@", levelKey, levelId];
    [mu addObject:pp];
    //        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
    //        [mu addObject:b];
    NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
    // 重置过滤
    vk.predicate = reSetPredicate;
  }
}

- (void)filerPoisOnLevelIds:(NSArray *)levelIds exceptPoiIds:(NSArray *)poiIds {
  NSArray *arr = self.layers;
  for (MGLStyleLayer *k in arr) {
    // 过滤不需要处理的layer
    if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
      continue;
    }
    MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
    NSString *ident = vk.identifier;
    if (![ident hasPrefix:@"mapxus"] || [ident hasPrefix:@"mapxus-building"] || [vk.sourceLayerIdentifier hasPrefix:@"mapxus_venue"] || ![ident hasPrefix:@"mapxus-poi"]) {
      continue;
    }
    NSString *levelKey = @"ref:level";
    
    NSPredicate *pp = [NSPredicate predicateWithFormat:@"%K IN %@", levelKey, levelIds];
    // 处理剩下需要添加filter的layer
    id originalPredicate = vk.predicate;
    NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
    if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
      NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
      for (NSCompoundPredicate *s in sub) {
        NSString *str = s.predicateFormat;
        if (![str containsString:[NSString stringWithFormat:@"%@ IN", levelKey]] &&
            ![str containsString:@"osm:ref IN"]) {
          [mu addObject:s];
        }
      }
    } else {
      if (originalPredicate) {
        [mu addObject:originalPredicate];
      }
    }
    //        NSPredicate *f = [NSPredicate predicateWithFormat:@"%K == %@", levelKey, levelId];
    [mu addObject:pp];
    NSPredicate *po = [NSPredicate predicateWithFormat:@"%K IN %@", @"osm:ref", poiIds];
    NSCompoundPredicate *npo = [NSCompoundPredicate notPredicateWithSubpredicate:po];
    [mu addObject:npo];
    //        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
    //        [mu addObject:b];
    NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
    // 重置过滤
    vk.predicate = reSetPredicate;
  }
}


//- (void)setLevelIdsTransparent:(NSArray *)levelIds {
//  NSArray *arr = self.layers;
//  for (MGLStyleLayer *k in arr) {
//    // 过滤不需要处理的layer
//    if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
//      continue;
//    }
//    MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
//    NSString *ident = vk.identifier;
//    if (![ident hasPrefix:@"mapxus"] || [ident hasPrefix:@"mapxus-building"] || [vk.sourceLayerIdentifier hasPrefix:@"mapxus_venue"]) {
//        continue;
//    }
//
//    NSString *levelKey = @"ref:level";
//    if ([vk.sourceLayerIdentifier hasPrefix:@"mapxus_level"]) {
//        levelKey = @"id";
//    }
//    NSPredicate *pp = [NSPredicate predicateWithFormat:@"%K IN %@", levelKey, levelIds];
//    if ([k isKindOfClass:[MGLCircleStyleLayer class]]) {
//      MGLCircleStyleLayer *ck = (MGLCircleStyleLayer *)k;
//      ck.circleOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                     trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                   falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      
//    } else if ([k isKindOfClass:[MGLFillStyleLayer class]]) {
//      MGLFillStyleLayer *ck = (MGLFillStyleLayer *)k;
//      ck.fillOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                   trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                 falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      
//    } else if ([k isKindOfClass:[MGLLineStyleLayer class]]) {
//      MGLLineStyleLayer *ck = (MGLLineStyleLayer *)k;
//      ck.lineOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                   trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                 falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      
//    } else if ([k isKindOfClass:[MGLSymbolStyleLayer class]]) {
//      MGLSymbolStyleLayer *ck = (MGLSymbolStyleLayer *)k;
//      ck.iconOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                   trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                 falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      ck.textOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                   trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                 falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      
//    } else if ([k isKindOfClass:[MGLHeatmapStyleLayer class]]) {
//      MGLHeatmapStyleLayer *ck = (MGLHeatmapStyleLayer *)k;
//      ck.heatmapOpacity = [NSExpression mgl_expressionForConditional:pp
//                                                      trueExpression:[NSExpression expressionForConstantValue:@(1)]
//                                                    falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
//      
//    }
////    else if ([k isKindOfClass:[MGLFillExtrusionStyleLayer class]]) {
////      MGLFillExtrusionStyleLayer *ck = (MGLFillExtrusionStyleLayer *)k;
////      ck.fillExtrusionOpacity = [NSExpression mgl_expressionForConditional:pp
////                                                            trueExpression:[NSExpression expressionForConstantValue:@(1)]
////                                                          falseExpresssion:[NSExpression expressionForConstantValue:@(0.4)]];
////
////    }
//  }
//}

- (void)outLineLevelBorderStyle:(MXMBorderStyle *)borderStyle {
  MGLStyleLayer *line_layer = [self layerWithIdentifier:@"assistant-mapxus-level-outline"];
  if ([line_layer isKindOfClass:[MGLLineStyleLayer class]]) {
    MGLLineStyleLayer *level_line = (MGLLineStyleLayer *)line_layer;
    level_line.lineWidth = borderStyle.lineWidth;
    level_line.lineOffset = borderStyle.lineWidth;
    level_line.lineColor = borderStyle.lineColor;
    level_line.lineOpacity = borderStyle.lineOpacity;
  }
}

- (void)outLineLevel:(NSString *)levelId {
  MGLStyleLayer *line_layer = [self layerWithIdentifier:@"assistant-mapxus-level-outline"];
  if ([line_layer isKindOfClass:[MGLLineStyleLayer class]]) {
    MGLLineStyleLayer *level_line = (MGLLineStyleLayer *)line_layer;
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"$geometryType = 'Polygon'"];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"id == %@", levelId];
    level_line.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
  }
}

- (MGLFillStyleLayer *)copyFillLayerWith:(MGLFillStyleLayer *)orig source:(MGLSource *)source {
  MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-mxmrear", orig.identifier] source:source];
  layer.fillSortKey = orig.fillSortKey;
  layer.fillAntialiased = orig.isFillAntialiased;
  layer.fillColor = orig.fillColor;
  layer.fillColorTransition = orig.fillColorTransition;
  layer.fillOpacity = orig.fillOpacity;
  layer.fillOpacityTransition = orig.fillOpacityTransition;
  layer.fillOutlineColor = orig.fillOutlineColor;
  layer.fillOutlineColorTransition = orig.fillOutlineColorTransition;
  layer.fillPattern = orig.fillPattern;
  layer.fillPatternTransition = orig.fillPatternTransition;
  layer.fillTranslation = orig.fillTranslation;
  layer.fillTranslationTransition = orig.fillTranslationTransition;
  layer.fillTranslationAnchor = orig.fillTranslationAnchor;
  layer.sourceLayerIdentifier = orig.sourceLayerIdentifier;
  layer.predicate = orig.predicate;
  layer.visible = orig.isVisible;
  layer.maximumZoomLevel = orig.maximumZoomLevel;
  layer.minimumZoomLevel = orig.minimumZoomLevel;
  return layer;
}

- (MGLLineStyleLayer *)copyLineLayerWith:(MGLLineStyleLayer *)orig source:(MGLSource *)source {
  MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-mxmrear", orig.identifier] source:source];
  layer.lineCap = orig.lineCap;
  layer.lineJoin = orig.lineJoin;
  layer.lineMiterLimit = orig.lineMiterLimit;
  layer.lineRoundLimit = orig.lineRoundLimit;
  layer.lineSortKey = orig.lineSortKey;
  layer.lineBlur = orig.lineBlur;
  layer.lineBlurTransition = orig.lineBlurTransition;
  layer.lineColor = orig.lineColor;
  layer.lineColorTransition = orig.lineColorTransition;
  layer.lineDashPattern = orig.lineDashPattern;
  layer.lineDashPatternTransition = orig.lineDashPatternTransition;
  layer.lineGapWidth = orig.lineGapWidth;
  layer.lineGapWidthTransition = orig.lineGapWidthTransition;
  layer.lineGradient = orig.lineGradient;
  layer.lineOffset = orig.lineOffset;
  layer.lineOffsetTransition = orig.lineOffsetTransition;
  layer.lineOpacity = orig.lineOpacity;
  layer.lineOpacityTransition = orig.lineOpacityTransition;
  layer.linePattern = orig.linePattern;
  layer.linePatternTransition = orig.linePatternTransition;
  layer.lineTranslation = orig.lineTranslation;
  layer.lineTranslationTransition = orig.lineTranslationTransition;
  layer.lineTranslationAnchor = orig.lineTranslationAnchor;
  layer.lineWidth = orig.lineWidth;
  layer.lineWidthTransition = orig.lineWidthTransition;
  layer.sourceLayerIdentifier = orig.sourceLayerIdentifier;
  layer.predicate = orig.predicate;
  layer.visible = orig.isVisible;
  layer.maximumZoomLevel = orig.maximumZoomLevel;
  layer.minimumZoomLevel = orig.minimumZoomLevel;
  return layer;
}

- (MGLSymbolStyleLayer *)copySymbolLayerWith:(MGLSymbolStyleLayer *)orig source:(MGLSource *)source {
  MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-mxmrear", orig.identifier] source:source];
  layer.iconAllowsOverlap = orig.iconAllowsOverlap;
  layer.iconAnchor = orig.iconAnchor;
  layer.iconIgnoresPlacement = orig.iconIgnoresPlacement;
  layer.iconImageName = orig.iconImageName;
  layer.iconOffset = orig.iconOffset;
  layer.iconOptional = orig.isIconOptional;
  layer.iconPadding = orig.iconPadding;
  layer.iconPitchAlignment = orig.iconPitchAlignment;
  layer.iconRotation = orig.iconRotation;
  layer.iconRotationAlignment = orig.iconRotationAlignment;
  layer.iconScale = orig.iconScale;
  layer.iconTextFit = orig.iconTextFit;
  layer.iconTextFitPadding = orig.iconTextFitPadding;
  layer.keepsIconUpright = orig.keepsIconUpright;
  layer.keepsTextUpright = orig.keepsTextUpright;
  layer.maximumTextAngle = orig.maximumTextAngle;
  layer.maximumTextWidth = orig.maximumTextWidth;
  layer.symbolAvoidsEdges = orig.symbolAvoidsEdges;
  layer.symbolPlacement = orig.symbolPlacement;
  layer.symbolSortKey = orig.symbolSortKey;
  layer.symbolSpacing = orig.symbolSpacing;
  layer.symbolZOrder = orig.symbolZOrder;
  layer.text = orig.text;
  layer.textAllowsOverlap = orig.textAllowsOverlap;
  layer.textAnchor = orig.textAnchor;
  layer.textFontNames = orig.textFontNames;
  layer.textFontSize = orig.textFontSize;
  layer.textIgnoresPlacement = orig.textIgnoresPlacement;
  layer.textJustification = orig.textJustification;
  layer.textLetterSpacing = orig.textLetterSpacing;
  layer.textLineHeight = orig.textLineHeight;
  layer.textOffset = orig.textOffset;
  layer.textOptional = orig.isTextOptional;
  layer.textPadding = orig.textPadding;
  layer.textPitchAlignment = orig.textPitchAlignment;
  layer.textRadialOffset = orig.textRadialOffset;
  layer.textRotation = orig.textRotation;
  layer.textRotationAlignment = orig.textRotationAlignment;
  layer.textTransform = orig.textTransform;
  layer.textVariableAnchor = orig.textVariableAnchor;
  layer.textWritingModes = orig.textWritingModes;
  layer.iconColor = orig.iconColor;
  layer.iconColorTransition = orig.iconColorTransition;
  layer.iconHaloBlur = orig.iconHaloBlur;
  layer.iconHaloBlurTransition = orig.iconHaloBlurTransition;
  layer.iconHaloColor = orig.iconHaloColor;
  layer.iconHaloColorTransition = orig.iconHaloColorTransition;
  layer.iconHaloWidth = orig.iconHaloWidth;
  layer.iconHaloWidthTransition = orig.iconHaloWidthTransition;
  layer.iconOpacity = orig.iconOpacity;
  layer.iconOpacityTransition = orig.iconOpacityTransition;
  layer.iconTranslation = orig.iconTranslation;
  layer.iconTranslationTransition = orig.iconTranslationTransition;
  layer.iconTranslationAnchor = orig.iconTranslationAnchor;
  layer.textColor = orig.textColor;
  layer.textColorTransition = orig.textColorTransition;
  layer.textHaloBlur = orig.textHaloBlur;
  layer.textHaloBlurTransition = orig.textHaloBlurTransition;
  layer.textHaloColor = orig.textHaloColor;
  layer.textHaloColorTransition = orig.textHaloColorTransition;
  layer.textHaloWidth = orig.textHaloWidth;
  layer.textHaloWidthTransition = orig.textHaloWidthTransition;
  layer.textOpacity = orig.textOpacity;
  layer.textOpacityTransition = orig.textOpacityTransition;
  layer.textTranslation = orig.textTranslation;
  layer.textTranslationTransition = orig.textTranslationTransition;
  layer.textTranslationAnchor = orig.textTranslationAnchor;
  layer.sourceLayerIdentifier = orig.sourceLayerIdentifier;
  layer.predicate = orig.predicate;
  layer.visible = orig.isVisible;
  layer.maximumZoomLevel = orig.maximumZoomLevel;
  layer.minimumZoomLevel = orig.minimumZoomLevel;
  return layer;
}

// 还要对不同类型进行区分赋值，有点麻烦，但可用于生成copy代码
//- (NSArray<YYClassPropertyInfo *> *)getClassAllRWProperties:(Class)cls {
//  NSMutableArray *propertyArray = [NSMutableArray array];
//  while (cls != [NSObject class]) {
//    // 获取所有属性
//    unsigned int count;
//    objc_property_t *properties = class_copyPropertyList(cls, &count);
//    for (unsigned int i = 0; i < count; i++) {
//      objc_property_t property = properties[i];
//      YYClassPropertyInfo *info = [[YYClassPropertyInfo alloc] initWithProperty:property];
//      // 检查属性是否为 readwrite
//      if (!(info.type & YYEncodingTypePropertyReadonly)) {
//        [propertyArray addObject:info];
//      }
//    }
//    free(properties);
//    // 继续遍历父类
//    cls = [cls superclass];
//  }
//  return [propertyArray copy];
//}


@end
