#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint secure_display.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'secure_display'
  s.version          = '0.1.0'
  s.summary          = 'A Flutter package for secure screen protection.'
  s.description      = <<-DESC
A Flutter package for secure screen protection including screenshot and screen recording prevention.
                       DESC
  s.homepage         = 'https://bitbucket.org/ninjafactory/secure-screen'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jagadeeswar Bollavaram' => 'jagadeeswarreddy.bollavaram@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end


