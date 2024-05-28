#!/bin/sh

find ./Document/Classes -type f -exec sed -i '' -e 's/MXMultilingualObjectString/MXMultilingualObject\&lt;NSString *\&gt;/g' -e 's/MXMultilingualObjectAddress/MXMultilingualObject\&lt;MXMAddress *\&gt;/g' {} \;
