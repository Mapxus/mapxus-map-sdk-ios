//
//  MGLStyle+MXMFilter.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/11/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MXMBorderStyle.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLStyle (MXMFilter)

- (void)MXMlocalizeLabelsIntoLocale:(nullable NSString *)localeLanguage;

- (void)updateBuildingFillOpacityWithIndoorState:(BOOL)isIndoor refVenue:(nullable NSString *)venueId;

- (void)filerLevelIds:(NSArray *)levelIds;

//- (void)setLevelIdsTransparent:(NSArray *)levelIds;

- (void)outLineLevelBorderStyle:(MXMBorderStyle *)borderStyle;

- (void)outLineLevel:(NSString *)levelId;

@end

NS_ASSUME_NONNULL_END
