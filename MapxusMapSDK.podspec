
Pod::Spec.new do |s|

  s.name         = "MapxusMapSDK"
  s.version      = "2.7.0"
  s.summary      = "Indoor map SDK."
  s.description  = <<-DESC
  To be the largest global indoor map.
                   DESC
  s.homepage     = "http://www.mapxus.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Mapxus" => "developer@maphive.io" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => 'https://github.com/MapxusSample/mapxus-map-sdk-ios.git', :tag => "#{s.version}" }
  s.requires_arc = true
  s.module_name  = "MapxusMapSDK"
  s.vendored_frameworks = "MapxusMapSDK/MapxusMapSDK.framework"
  s.dependency "AFNetworking", "~> 3.2.1"
  s.dependency "YYModel", "~> 1.0.4"
  s.dependency "Mapbox-iOS-SDK", "~> 4.6.0"

end