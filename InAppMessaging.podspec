Pod::Spec.new do |s|
  s.name             = 'InAppMessaging'
  s.version          = '1.0.0'
  s.summary          = 'Rakuten SDK to help push notifications to mobile devices.'
  s.homepage         = 'https://confluence.rakuten-it.com/confluence/display/SSEDPT/iOS+IAM+SDK+Usage+Tutorial'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Tam' => 'daniel.a.tam@rakuten.com' }
  s.source           = { :git => 'https://gitpub.rakuten-it.com/projects/ECO/repos/ios-insights.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'InAppMessaging/Classes/**/*.{swift,h,m}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Swinject'
  s.dependency 'SDWebImage'
end
