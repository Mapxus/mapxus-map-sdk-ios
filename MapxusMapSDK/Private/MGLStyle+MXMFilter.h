//
//  MGLStyle+MXMFilter.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/11/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLStyle (MXMFilter)

- (void)MXMlocalizeLabelsIntoLocale:(nullable NSString *)localeLanguage;

- (void)updateBuildingFillOpacityWithIndoorState:(BOOL)isIndoor;

- (void)filerLevelIds:(NSArray *)levelIds;

@end

NS_ASSUME_NONNULL_END
