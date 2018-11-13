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
        
        if ([localeLanguage containsString:@"en"]) {
            ((MGLSymbolStyleLayer *)k).text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K})", @"name_en", @"name:en", @"name"];
            
        } else if ([localeLanguage containsString:@"zh-Hant"]) {
            ((MGLSymbolStyleLayer *)k).text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K})", @"name_zh", @"name:zh", @"name_zh-Hans", @"name"];
            
        } else if ([localeLanguage containsString:@"zh-Hans"]) {
            ((MGLSymbolStyleLayer *)k).text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K, %K, %K, %K})", @"name_zh-Hans", @"name:cn", @"name_zh", @"name"];
            
        } else {
            ((MGLSymbolStyleLayer *)k).text = [NSExpression expressionWithFormat:@"mgl_coalesce({%K})", @"name"];
        }
    }
}

@end
