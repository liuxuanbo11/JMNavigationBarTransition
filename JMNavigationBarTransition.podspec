#
#  Be sure to run `pod spec lint JMNavigationBarTransition.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "JMNavigationBarTransition"
s.version      = "0.0.1"
s.summary      = "Transition"

s.description  = <<-DESC
NavBarTransition
DESC

s.homepage     = "https://github.com/liuxuanbo11/JMNavigationBarTransition"
s.license      = "MIT"
s.author             = { "刘轩博" => "liuxuanbo11@126.com" }
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/liuxuanbo11/JMNavigationBarTransition.git", :tag => "#{s.version}" }

s.source_files  = "JMNavigationBarTransition/**/*.{h,m}"



end
