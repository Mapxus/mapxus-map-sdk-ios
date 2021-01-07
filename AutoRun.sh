#!/bin/sh

#  AutoRun.sh
#  MapxusMapSDK
#
#  Created by chenghao guo on 2020/10/14.
#  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.

#
ENV=""
#
COM=""
# 手动使用本工具打包时，可以不传-d参数，使用本默认值
FRAMEWORK_ROOT_PATH="${PWD}/.."

# c: 公司，可选mapxus、landsd
# d: framework文件存放根目录
# e: 环境，可选test、prod
while getopts ":c:d:e:" opt
do
    case $opt in
        d)
        FRAMEWORK_ROOT_PATH=$OPTARG
        ;;
        e)
        if [[ $OPTARG == "test" ]]; then
            ENV="-test"
        fi
        ;;
        c)
        if [[ $OPTARG == "landsd" ]]; then
            COM="-landsd"
        fi
        ;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done

####################### 替换地址
HOSTURL=""

SourceCopyrightTitle=""
SourceCopyrightURL=""

AboutSourceTitle=""
AboutSourceURL=""

if [[ -z $COM ]] && [[ -z $ENV ]]; then
    HOSTURL="https:\/\/mapxusprod.blob.core.windows.net\/com-mapxus-sdk\/prod\/version.json"
    SourceCopyrightTitle="© OpenStreetMap contributors"
    SourceCopyrightURL="https:\/\/www.openstreetmap.org\/copyright"
    AboutSourceTitle="© OpenStreeMap"
    AboutSourceURL="https:\/\/www.openstreetmap.org\/about\/"
    
elif [[ -z $COM ]] && [[ $ENV == "-test" ]]; then
    HOSTURL="https:\/\/mapxustest.blob.core.windows.net\/com-mapxus-sdk\/test\/version.json"
    SourceCopyrightTitle="© OpenStreetMap contributors"
    SourceCopyrightURL="https:\/\/www.openstreetmap.org\/copyright"
    AboutSourceTitle="© OpenStreeMap"
    AboutSourceURL="https:\/\/www.openstreetmap.org\/about\/"
    
elif [[ $COM == "-landsd" ]] && [[ -z $ENV ]]; then
    HOSTURL="https:\/\/landsd.blob.core.windows.net\/com-mapxus-sdk\/landsd\/version.json"
    SourceCopyrightTitle="© The Government of the Hong Kong SAR"
    SourceCopyrightURL="https:\/\/www.map.gov.hk\/gm\/"
    AboutSourceTitle="© The Government of the Hong Kong SAR"
    AboutSourceURL="https:\/\/www.map.gov.hk\/gm\/"

elif [[ $COM == "-landsd" ]] && [[ $ENV == "-test" ]]; then
    HOSTURL="https:\/\/landsdtest.blob.core.windows.net\/com-mapxus-sdk\/landsd-test\/version.json"
    SourceCopyrightTitle="© The Government of the Hong Kong SAR"
    SourceCopyrightURL="https:\/\/www.map.gov.hk\/gm\/"
    AboutSourceTitle="© The Government of the Hong Kong SAR"
    AboutSourceURL="https:\/\/www.map.gov.hk\/gm\/"

fi

#匹配项
Orgin='NSString \*cacheVersionUrl =.*$'
New='NSString \*cacheVersionUrl = @"'${HOSTURL}'";'

SourceCopyrightTitleOrgin='#define SourceCopyrightTitle.*$'
SourceCopyrightTitleNew='#define SourceCopyrightTitle @"'${SourceCopyrightTitle}'"'

SourceCopyrightURLOrgin='#define SourceCopyrightURL.*$'
SourceCopyrightURLNew='#define SourceCopyrightURL @"'${SourceCopyrightURL}'"'

AboutSourceTitleOrgin='#define AboutSourceTitle.*$'
AboutSourceTitleNew='#define AboutSourceTitle @"'${AboutSourceTitle}'"'

AboutSourceURLOrgin='#define AboutSourceURL.*$'
AboutSourceURLNew='#define AboutSourceURL @"'${AboutSourceURL}'"'

#替换地址
sed -i '' "s/${Orgin}/${New}/g" MapxusMapSDK/Private/MXMCacheManager.m
sed -i '' "s/${SourceCopyrightTitleOrgin}/${SourceCopyrightTitleNew}/g" MapxusMapSDK/Private/StringDefine.h
sed -i '' "s/${SourceCopyrightURLOrgin}/${SourceCopyrightURLNew}/g" MapxusMapSDK/Private/StringDefine.h
sed -i '' "s/${AboutSourceTitleOrgin}/${AboutSourceTitleNew}/g" MapxusMapSDK/Private/StringDefine.h
sed -i '' "s/${AboutSourceURLOrgin}/${AboutSourceURLNew}/g" MapxusMapSDK/Private/StringDefine.h

####################### 替换地址

FRAMEWORK_DIR="$FRAMEWORK_ROOT_PATH/mapxus-map-sdk-ios-template/dynamic"
#目录如果不存在，则拉取github
if [[ ! -d "${FRAMEWORK_DIR}" ]]
then
  git clone git@gitee.com:150vb/mapxus-map-sdk-ios-template.git "$FRAMEWORK_ROOT_PATH/mapxus-map-sdk-ios-template"
fi

#打包并复制到目录
pod install
xcodebuild -workspace MapxusMapSDK.xcworkspace -scheme MapxusMapSDK-Universal POD_DIR="$FRAMEWORK_DIR"
