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
        if (![ident hasPrefix:@"mapxus"] || [ident hasPrefix:@"mapxus-building"] || [vk.sourceLayerIdentifier hasPrefix:@"mapxus_venue"]) {
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

@end
