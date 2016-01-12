#
#  Be sure to run `pod spec lint QMChatViewController.podspec --verbose --use-libraries --allow-warnings' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#   
#  To submit use `pod trunk push QMChatViewController.podspec --verbose --use-libraries --allow-warnings`
#

Pod::Spec.new do |s|

  s.name         = "QMChatViewController"
  s.version      = "0.3.3"
  s.summary      = "An elegant ready-to-go chat view controller for iOS chat applications that use Quickblox communication backend."

  s.description  = <<-DESC
					* Ready-to-go chat view controller with a set of cells.
					* Automatic cell size calculation.
					* UI customisation for chat cells.
					* Flexibility in improving and extending functionality.
					* Easy to connect with Quickblox.
					* Optimised and performant.
					* Supports portrait and landscape orientations.
					* Auto Layout inside.
                   DESC

  s.homepage     = "https://github.com/QuickBlox/QMChatViewController-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrey Ivanov" => "andrey.ivanov@quickblox.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/QuickBlox/QMChatViewController-ios.git", :tag => "#{s.version}" }
  s.source_files = "QMChatViewController/QMChatViewController.{h,m}"

  s.subspec 'Utils' do |ss| 
    ss.source_files = 'QMChatViewController/Utils/QMDateUtils/*.{h,m}'
  end

  s.subspec 'Sections' do |ss|
    ss.source_files = 'QMChatViewController/QMChatSection/*.{h,m}'
  end

  s.subspec 'Categories' do |ss|
    ss.source_files = 'QMChatViewController/Categories/*.{h,m}'
  end

  s.subspec 'KeyboardViewController' do |ss|
    ss.source_files = 'QMChatViewController/KeyboardViewController/*.{h,m}'
  end

  s.subspec 'Protocols' do |ss|
    ss.source_files = 'QMChatViewController/Protocols/*.{h}'
  end

  s.subspec 'DataSource' do |ss|
    ss.source_files = 'QMChatViewController/DataSource/*.{h,m}'
  end

  s.subspec 'Views' do |ss|
  	ss.dependency 'QMChatViewController/Protocols'
  	ss.dependency 'QMChatViewController/Categories'

    ss.source_files = 'QMChatViewController/Views/**/*.{h,m}'
  end

  s.resources = ["QMChatViewController/**/*.xib", "QMChatViewController/**/*.xcassets"]
  s.requires_arc = true
  s.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/QuickBlox/" }
  s.prefix_header_contents = '#import <Quickblox/Quickblox.h>'
  s.dependency "QuickBlox", "~> 2.0"
  s.dependency "TTTAttributedLabel", "~> 1.13"
  s.dependency "SDWebImage", "~> 3.6"

end
