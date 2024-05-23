//
//  MXMultilingualObject.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/4/28.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///  This is a generic multilingual object class, designed to store and manage objects in different languages.
@interface MXMultilingualObject<ObjectType> : NSObject <NSCopying>
///  The default object, which can be used when a specific language object is not available.
@property (nonatomic, copy, nullable) ObjectType Default;
///  The object in English.
@property (nonatomic, copy, nullable) ObjectType en;
/// The object in Simplified Chinese.
@property (nonatomic, copy, nullable) ObjectType zh_Hans;
/// The object in Traditional Chinese.
@property (nonatomic, copy, nullable) ObjectType zh_Hant;
/// The object in Japanese.
@property (nonatomic, copy, nullable) ObjectType ja;
/// The object in Korean.
@property (nonatomic, copy, nullable) ObjectType ko;

@end

NS_ASSUME_NONNULL_END
