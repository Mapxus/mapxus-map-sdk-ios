#!/bin/sh

#  document.sh
#  MapxusMapSDK
#
#  Created by Chenghao Guo on 2018/7/31.
#  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.

#jazzy \
#--objc \
#--clean \
#--theme apple \
#--sdk iphoneos \
#--skip-undocumented \
#--hide-documentation-coverage \
#--framework-root ./MapxusMapSDK \
#--source-directory ./MapxusMapSDK/ \
#--module MapxusMapSDK \
#--module-version ${SHORT_VERSION} \
#--author "Maphive Technology Limited" \
#--author_url http://www.mapxus.com/ \
#--umbrella-header ./MapxusMapSDK/MapxusMapSDK.h \
#--exclude ./MapxusMapSDK/PrivateFile \
#--hide-declarations swift \
#--output "${PROJECT_DIR}/Document" \

#appledoc Xcode script
# Start constants
company="Maphive Technology Investment Limited.";
companyURL="http://www.mapxus.com/";
target="iphoneos";
outputPath="${PROJECT_DIR}/Document";
# End constants

appledoc \
--project-name "${PROJECT_NAME}" \
--project-company "${company}" \
--output "${outputPath}" \
--logformat xcode \
--create-html \
--no-create-docset \
--no-install-docset \
--no-publish-docset \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--exit-threshold 2 \
-i MapxusMapSDK/Private \
-i MapxusMapSDK/FoundationKit \
-i MapxusMapSDK/Operations \
-i MapxusMapSDK/Controllers/KxMenu \
-i MapxusMapSDK/Controllers/MXMPicker \
-i MapxusMapSDK/Controllers/MXMFloorSelectorBar.m \
"${PROJECT_DIR}/MapxusMapSDK"
