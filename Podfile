source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def pods
  pod 'SnapKit', '~> 0.22.0'
  pod 'DateTools'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'IQKeyboardManagerSwift'
  pod 'Charts', :git => 'git@github.com:danielgindi/Charts.git', :branch => 'Chart2.2.5-Swift2.3'
  pod 'Google/Analytics'
  pod 'Pingpp/Alipay'
  pod 'Pingpp/Wx'
  pod 'MOBFoundation'
  pod 'ShareSDK3'
  pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
end

target 'parent-dev' do
  pods

  target 'parentTests' do
    inherit! :search_paths
  end
end

target 'parent-stage' do
  pods
end

target 'parent-prd' do
  pods
end
