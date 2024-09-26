#!/bin/sh

#  document.sh
#  MapxusMapSDK
#
#  Created by Chenghao Guo on 2018/7/31.
#  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.

###### 文档生成方式
# 1. 先使用AutoBuild脚本对项目打包一次
# 2. 把MapxusMapSDK.h文件中的尖括号引用全改成双引号引用，如#import <MapxusMapSDK/MXMDefine.h>改成#import "MXMDefine.h"
######


# Start constants
company="Maphive Technology Investment Limited.";
companyURL="http://www.mapxus.com/";
target="iphoneos";
outputPath="./Document";
# End constants

jazzy \
--output "${outputPath}" \
--theme fullwidth \
--clean \
--objc \
--framework-root . \
--umbrella-header MapxusMapSDK/MapxusMapSDK.h \
--source-directory MapxusMapSDK \
--author "${company}" \
--author_url "${companyURL}" \
--module MapxusMapSDK \
--module-version 6.11.0 \
--readme README.md \
--disable-search \
--skip-undocumented \
--hide-documentation-coverage \
--exclude MapxusMapSDK/Private,MapxusMapSDK/FoundationKit,MapxusMapSDK/Operations,MapxusMapSDK/Controllers/KxMenu
