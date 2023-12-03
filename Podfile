platform :ios, '17.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Setlist.xcworkspace'
project 'Projects/App/Seta.xcodeproj'
project 'Projects/Core/Core.xcodeproj'
project 'Projects/Feature/Feature.xcodeproj'
project 'Projects/UI/UI.xcodeproj'

target 'Seta' do
   project 'Projects/App/Seta.xcodeproj'
   pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
pod 'SwiftUIIntrospect', '~> 1.0'
end

target 'Core' do
   project 'Projects/Core/Core.xcodeproj'
   pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
pod 'SwiftUIIntrospect', '~> 1.0'
end

target 'Feature' do
   project 'Projects/Feature/Feature.xcodeproj'
   pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
pod 'SwiftUIIntrospect', '~> 1.0'
end

target 'UI' do
   project 'Projects/UI/UI.xcodeproj'
   pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
pod 'SwiftUIIntrospect', '~> 1.0'
end
