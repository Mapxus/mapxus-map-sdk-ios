#!/bin/sh

#  ResourceManagement.sh
#  MapxusMapSDK
#
#  Created by guochenghao on 2024/5/17.
#  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.

PWD=${1}
COM=${2}

if [[ $COM == "-kawasaki" ]]; then
  cp "$PWD/MapxusMapSDK/MapxusBundle/mapxus_jp_icon.pdf" "$PWD/MapxusMapSDK/MapxusBundle/images.xcassets/mapxus_icon.imageset/mapxus_icon.pdf"
else
  cp "$PWD/MapxusMapSDK/MapxusBundle/mapxus_icon.pdf" "$PWD/MapxusMapSDK/MapxusBundle/images.xcassets/mapxus_icon.imageset/mapxus_icon.pdf"
fi
