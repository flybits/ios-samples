platform :ios, '12.0'
workspace 'ios-samples'

source 'https://github.com/flybits/Spec-XCFramework.git'

use_frameworks!

$flybitsSDKVersion = '~> 4.1'

target 'Anonymous-Connect' do
    project 'Connection/Anonymous-Connect/Anonymous-Connect.xcodeproj'
    inherit! :search_paths

    # Pods
    pod 'FlybitsSDK', $flybitsSDKVersion
end

target 'Expose-Bank' do
  project 'Concierge/Expose-Bank/Expose-Bank.xcodeproj'
  inherit! :search_paths

  # Pods
  pod 'FlybitsConcierge', $flybitsSDKVersion
end
