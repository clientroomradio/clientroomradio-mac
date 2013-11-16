# This will tell cocoapods the name of the workspace to generate for us.
workspace 'Client Room Radio'
 
# We have to define a default platform. We tell cocoapods where to find
# the Xcode project and which target to link against. This isn't ideal
# and someone should file a feature request against cocoapods.
platform :ios, '6.0'
xcodeproj 'Client Room Radio.xcodeproj'
link_with 'Client Room Radio iOS'
 
# Here, we define a new target named 'osx'. Cocoapods will generate a
# separate static library that contains any dependencies listed here
# and in our default group that only links against our OS X target.
target :osx do
platform :osx, '10.8'
link_with 'Client Room Radio'
xcodeproj 'Client Room Radio.xcodeproj'
 
# Dependencies here will only be linked against the OS X target.
pod 'SocketRocket', '~> 0.3.1-beta2'
 
end
 
# This will generate another library that will link against
# the iOS target. We don't want to inherit any default pods
# (since our default library will already link against the
# iOS target) so we mark it as exclusive.
target :ios, exclusive: true do
xcodeproj 'Client Room Radio.xcodeproj'
link_with 'Client Room Radio iOS'

pod 'SocketRocket', '~> 0.3.1-beta2'
pod 'TPKeyboardAvoiding'
pod 'TestFlightSDK'
pod 'ViewDeck', '2.2.11'

end