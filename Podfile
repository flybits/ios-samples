
platform :ios, '9.0'

workspace 'ios-samples'

use_frameworks!

$flybitsSource = 'https://github.com/flybits/Spec-Xcode-11.3.1.git'

target 'Anonymous-Connect' do
    project 'Connection/Anonymous-Connect/Anonymous-Connect.xcodeproj'
    inherit! :search_paths

    # Pods
    pod 'FlybitsSDK', '~> 3.0', :source => $flybitsSource
end
