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

- (void)updateBuildingFillOpacityWith:(NSString *)buildingId indoorState:(BOOL)isIndoor;

- (void)filerBuildingId:(NSString *)buildingId floor:(NSString *)floor levelId:(NSString *)levelId;

@end

NS_ASSUME_NONNULL_END
