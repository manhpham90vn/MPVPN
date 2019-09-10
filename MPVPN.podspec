#
# Be sure to run `pod lib lint MPVPN.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MPVPN'
  s.version          = '0.0.3'
  s.summary          = 'VPN wrapper for iOS'

  s.description      = <<-DESC
A VPN wrapper for iOS, using shared secret required IKEv2 VPN with PSK
                       DESC

  s.homepage         = 'https://github.com/manhpham90vn/MPVPN'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'manhpham90vn' => 'manhpham90vn@icloud.com' }
  s.source           = { :git => 'https://github.com/manhpham90vn/MPVPN.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'MPVPN/Classes/**/*'
  s.swift_version = '5.0'
end
