
Pod::Spec.new do |s|


  version = '4.0.3'

  s.name         = 'MapxusMapSDK'
  s.version      = version

  s.summary      = 'Indoor map SDK.'
  s.description  = 'To be the largest global indoor map.'
  s.homepage     = 'https://www.mapxus.com'
  s.license      = { :type => 'BSD 3-Clause', :file => 'LICENSE' }
  s.author       = { 'Mapxus' => 'developer@maphive.io' }

  s.platform     = :ios, '9.0'

  s.source       = { :http => "https://ios-sdk.mapxus.com/#{version.to_s}/mapxus-map-sdk-ios.zip", :flatten => true }
  
  s.requires_arc = true

  s.module_name  = 'MapxusMapSDK'
  s.vendored_frameworks = 'dynamic/MapxusMapSDK.xcframework'

  s.dependency "MapxusBaseSDK", version
  s.dependency "MapxusRenderSDK", "5.12.0"

  
end