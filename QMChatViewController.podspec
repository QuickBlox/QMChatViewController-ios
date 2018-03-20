#
#  Be sure to run `pod spec lint QMChatViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name = "QMChatViewController"
    s.version = "0.6.1"
    s.summary = "An elegant ready-to-go chat view controller for iOS chat applications that use Quickblox communication backend."

    s.description = <<-DESC
                    * Ready-to-go chat view controller with a set of cells.
                    * Automatic cell size calculation.
                    * UI customisation for chat cells.
                    * Flexibility in improving and extending functionality.
                    * Easy to connect with Quickblox.
                    * Optimised and performant.
                    * Supports portrait and landscape orientations.
                    * Auto Layout inside.
                    DESC

    s.homepage = "https://github.com/QuickBlox/QMChatViewController-ios"
    s.license = { :type => "BSD", :file => "LICENSE" }
    s.authors = {
        "Andrey Ivanov" => "andrey.ivanov@quickblox.com",
        "Vitaliy Gorbachov" => "vitaliy.gorbachov@quickblox.com",
        "Vitaliy Gurkovsky" => "vitaliy.gurkovsky@injoit.com"
    }
    s.platform = :ios, "9.0"
    s.source = {
        :git => "https://github.com/QuickBlox/QMChatViewController-ios.git",
        :tag => "#{s.version}"
    }
    s.source_files = "QMChatViewController/QMChatViewController.{h,m}"

    s.subspec 'QMChatLocationSnapshotter' do |ss|
        ss.source_files = 'QMChatViewController/QMChatLocationSnapshotter/*.{h,m}'
    end

    s.subspec 'Categories' do |ss|
        ss.dependency 'QMChatViewController/QMChatLocationSnapshotter'
        ss.source_files = 'QMChatViewController/Categories/*.{h,m}'
    end

    s.subspec 'Utils' do |ss|
        ss.dependency 'QMChatViewController/Categories'
        ss.source_files = 'QMChatViewController/Utils/**/*.{h,m}'
    end

    s.subspec 'ViewModels' do |ss|
        ss.dependency 'QMChatViewController/Categories'
        ss.source_files = 'QMChatViewController/ViewModels/**/*.{h,m}'
    end

    s.subspec 'Sections' do |ss|
        ss.dependency 'QMChatViewController/QMChatDataSource'
        ss.source_files = 'QMChatViewController/QMChatSection/*.{h,m}'
    end

    s.subspec 'QMChatDataSource' do |ss|
        ss.source_files = 'QMChatViewController/QMChatDataSource/*.{h,m}'
    end

    s.subspec 'Protocols' do |ss|
        ss.source_files = 'QMChatViewController/Protocols/*.{h}'
    end

    s.subspec 'Views' do |ss|
         ss.dependency 'QMChatViewController/Categories'
         ss.dependency 'QMChatViewController/Protocols'
         ss.dependency 'QMChatViewController/Utils'
         ss.source_files = 'QMChatViewController/Views/**/*.{h,m}'
    end

    s.resource_bundles = {
        'QMChatViewController' => [
            'QMChatViewController/**/*.xcassets',
            'QMChatViewController/**/*.xib'
        ]
    }
    s.resource = 'QMChatViewController/**/*.xcassets'
    s.requires_arc = true
    s.dependency "TTTAttributedLabel"
    s.dependency "SDWebImage"
    s.dependency "FFCircularProgressView"
    s.xcconfig = {
        "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/../../Framework $(PODS_ROOT)/../External"
    }

end
