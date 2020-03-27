
Pod::Spec.new do |s|

  s.name         = "MapxusMapSDK"
  s.version      = "3.10.1"
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
  s.dependency "MapxusBaseSDK", "3.10.1"
  s.dependency "Mapbox-iOS-SDK", "~> 5.7.0"

end