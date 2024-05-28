#!/bin/sh

#  document.sh
#  MapxusMapSDK
#
#  Created by Chenghao Guo on 2018/7/31.
#  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.

# Xcode script
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
--module-version 6.8.0 \
--readme README.md \
--hide-declarations swift \
--disable-search \
--skip-undocumented \
--hide-documentation-coverage \
--exclude MapxusMapSDK/Private,MapxusMapSDK/FoundationKit,MapxusMapSDK/Operations,MapxusMapSDK/Controllers/KxMenu


##appledoc Xcode script
## Start constants
#company="Maphive Technology Investment Limited.";
#companyURL="http://www.mapxus.com/";
#target="iphoneos";
#outputPath="${PROJECT_DIR}/Document";
## End constants
#
#appledoc \
#--project-name "${PROJECT_NAME}" \
#--project-company "${company}" \
#--output "${outputPath}" \
#--logformat xcode \
#--create-html \
#--no-create-docset \
#--no-install-docset \
#--no-publish-docset \
#--keep-intermediate-files \
#--no-repeat-first-par \
#--no-warn-invalid-crossref \
#--exit-threshold 2 \
#-i MapxusMapSDK/Private \
#-i MapxusMapSDK/FoundationKit \
#-i MapxusMapSDK/Operations \
#-i MapxusMapSDK/Controllers/KxMenu \
#-i MapxusMapSDK/Controllers/MXMPicker \
#-i MapxusMapSDK/Controllers/MXMFloorSelectorBar.m \
#"${PROJECT_DIR}/MapxusMapSDK"
