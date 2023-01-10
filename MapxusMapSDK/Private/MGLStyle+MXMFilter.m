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

- (void)updateBuildingFillOpacityWithIndoorState:(BOOL)isIndoor {
    MGLStyleLayer *layer = [self layerWithIdentifier:@"mapxus-building-line"];
    if ([layer isKindOfClass:[MGLFillStyleLayer class]]) {
        MGLFillStyleLayer *buildingFill = (MGLFillStyleLayer *)layer;
        if (isIndoor) {
            buildingFill.fillOpacity = [NSExpression expressionForConstantValue:@(0)];
        } else {
            buildingFill.fillOpacity = [NSExpression expressionForConstantValue:@(1)];
        }
    }
    
    // 因为需要在缩放时隐藏/显示，所以需要在这里设置过滤更新「mapxus-building-line-color」
//    MGLStyleLayer *line_layer = [self layerWithIdentifier:@"mapxus-building-line-color"];
//    if ([line_layer isKindOfClass:[MGLLineStyleLayer class]]) {
//        MGLLineStyleLayer *building_line = (MGLLineStyleLayer *)line_layer;
//        // 获取原始predicate队列
//        id originalPredicate = building_line.predicate;
//        NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
//        if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
//            NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
//            for (NSCompoundPredicate *s in sub) {
//                NSString *str = s.predicateFormat;
//                if (![str containsString:@"id !="]) {
//                    [mu addObject:s];
//                }
//            }
//        } else {
//            if (originalPredicate) {
//                [mu addObject:originalPredicate];
//            }
//        }
//        // 根据是否在室内修改predicate
//        if (isIndoor) {
//            NSPredicate *b = [NSPredicate predicateWithFormat:@"%K != %@", @"id", buildingId];
//            [mu addObject:b];
//        }
//        NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
//        // 重置过滤
//        building_line.predicate = reSetPredicate;
//    }

    MGLStyleLayer *line_layer = [self layerWithIdentifier:@"mapxus-building-line-color"];
    if ([line_layer isKindOfClass:[MGLLineStyleLayer class]]) {
        MGLLineStyleLayer *building_line = (MGLLineStyleLayer *)line_layer;
        if (isIndoor) {
            building_line.lineOpacity = [NSExpression expressionForConstantValue:@(0)];
        } else {
            building_line.lineOpacity = [NSExpression expressionForConstantValue:@(1)];
        }
    }

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

@end
