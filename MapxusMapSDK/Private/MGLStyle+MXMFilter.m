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
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K})", @"name_en", @"name:en", @"name"];
                
            } else if ([localeLanguage containsString:@"zh-Hant"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K})", @"name_zh", @"name:zh", @"name_zh-Hans", @"name"];
                
            } else if ([localeLanguage containsString:@"zh-Hans"]) {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K})", @"name_zh-Hans", @"name:cn", @"name_zh", @"name"];
                
            } else {
                sk.text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K})", @"name"];
            }
        }
    }
}

// 地图图层数据过滤，保证buildingId和floor不能为空
- (void)filerBuildingId:(NSString *)buildingId Floor:(NSString *)floor {
    NSArray *arr = self.layers;
    for (MGLStyleLayer *k in arr) {
        // 过滤不需要处理的layer
        if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
            continue;
        }
        MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
        NSString *ident = vk.identifier;
        if (![ident hasPrefix:@"maphive"] || [ident hasPrefix:@"maphive-building"]) {
            continue;
        }
        
        // 处理剩下需要添加filter的layer
        id originalPredicate = vk.predicate;
        NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
        if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
            NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
            for (NSCompoundPredicate *s in sub) {
                NSString *str = s.predicateFormat;
                if (![str containsString:@"floor =="] && ![str containsString:@"ref:building =="]) {
                    [mu addObject:s];
                }
            }
        } else {
            if (originalPredicate) {
                [mu addObject:originalPredicate];
            }
        }
        NSPredicate *f = [NSPredicate predicateWithFormat:@"floor == %@", floor];
        [mu addObject:f];
        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
        [mu addObject:b];
        NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
        // 重置过滤
        vk.predicate = reSetPredicate;
    }
}

@end
