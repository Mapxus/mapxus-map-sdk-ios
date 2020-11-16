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


####################### 替换cache version地址
#    NSString *cacheVersionUrl = @"https://mapxusprod.blob.core.windows.net/com-mapxus-sdk/prod/version.json";
#    NSString *cacheVersionUrl = @"https://mapxustest.blob.core.windows.net/com-mapxus-sdk/test/version.json";
#    NSString *cacheVersionUrl = @"https://landsdtest.blob.core.windows.net/com-mapxus-sdk/landsd-test/version.json";
#    NSString *cacheVersionUrl = @"https://landsd.blob.core.windows.net/com-mapxus-sdk/landsd/version.json";
HOSTURL=""

if [[ -z $COM ]] && [[ -z $ENV ]]; then
    HOSTURL="https:\/\/mapxusprod.blob.core.windows.net\/com-mapxus-sdk\/prod\/version.json"

elif [[ -z $COM ]] && [[ $ENV == "-test" ]]; then
    HOSTURL="https:\/\/mapxustest.blob.core.windows.net\/com-mapxus-sdk\/test\/version.json"

elif [[ $COM == "-landsd" ]] && [[ -z $ENV ]]; then
    HOSTURL="https:\/\/landsd.blob.core.windows.net\/com-mapxus-sdk\/landsd\/version.json"

elif [[ $COM == "-landsd" ]] && [[ $ENV == "-test" ]]; then
    HOSTURL="https:\/\/landsdtest.blob.core.windows.net\/com-mapxus-sdk\/landsd-test\/version.json"
    
fi

#
Orgin='NSString \*cacheVersionUrl =.*$'
New='NSString \*cacheVersionUrl = @"'${HOSTURL}'";'

#替换地址
sed -i '' "s/${Orgin}/${New}/g" MapxusMapSDK/Private/MXMCacheManager.m
####################### 替换cache version地址

FRAMEWORK_DIR="$FRAMEWORK_ROOT_PATH/mapxus-map-sdk-ios/MapxusMapSDK"
#目录如果不存在，则拉取github
if [[ ! -d "${FRAMEWORK_DIR}" ]]
then
  git clone https://github.com/Mapxus/mapxus-map-sdk-ios.git "$FRAMEWORK_ROOT_PATH/mapxus-map-sdk-ios"
fi

#打包并复制到目录
pod install
xcodebuild -workspace MapxusMapSDK.xcworkspace -scheme MapxusMapSDK-Universal POD_DIR="$FRAMEWORK_DIR"
