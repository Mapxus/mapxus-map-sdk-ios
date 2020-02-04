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
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K})", @"name:en", @"name_en", @"name"];
                
            } else if ([localeLanguage containsString:@"zh-Hant"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K, %K})", @"name:zh-Hant", @"name_zh", @"name:zh", @"name_zh-Hans", @"name"];
                
            } else if ([localeLanguage containsString:@"zh-Hans"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K, %K})", @"name:zh-Hans", @"name_zh-Hans", @"name:cn", @"name_zh", @"name"];
                
            } else if ([localeLanguage containsString:@"ja"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K})", @"name:ja", @"name"];
                
            } else if ([localeLanguage containsString:@"ko"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K})", @"name:ko", @"name"];
                
            } else {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K})", @"name"];
            }
        }
    }
}

- (void)updateBuildingFillOpacityWith:(NSString *)buildingId indoorState:(BOOL)isIndoor {
    MGLStyleLayer *layer = [self layerWithIdentifier:@"mapxus-building-line"];
    if ([layer isKindOfClass:[MGLFillStyleLayer class]]) {
        MGLFillStyleLayer *buildingFill = (MGLFillStyleLayer *)layer;
        if (isIndoor) {
            buildingFill.fillOpacity = [NSExpression mgl_expressionForConditional:[NSPredicate predicateWithFormat:@"id == %@", buildingId] trueExpression:[NSExpression expressionForConstantValue:@(0)] falseExpresssion:[NSExpression expressionForConstantValue:@(1)]];
        } else {
            buildingFill.fillOpacity = [NSExpression expressionForConstantValue:@(1)];
            
        }
    }
}

// 地图图层数据过滤，保证buildingId和floor不能为空
- (void)filerBuildingId:(NSString *)buildingId floor:(NSString *)floor levelId:(NSString *)levelId {
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
        
        // 处理剩下需要添加filter的layer
        id originalPredicate = vk.predicate;
        NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
        if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
            NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
            for (NSCompoundPredicate *s in sub) {
                NSString *str = s.predicateFormat;
                if (![str containsString:[NSString stringWithFormat:@"%@ ==", levelKey]] && ![str containsString:@"ref:building =="]) {
                    [mu addObject:s];
                }
            }
        } else {
            if (originalPredicate) {
                [mu addObject:originalPredicate];
            }
        }
        NSPredicate *f = [NSPredicate predicateWithFormat:@"%K == %@", levelKey, levelId];
        [mu addObject:f];
        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
        [mu addObject:b];
        NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
        // 重置过滤
        vk.predicate = reSetPredicate;
    }
}

@end
