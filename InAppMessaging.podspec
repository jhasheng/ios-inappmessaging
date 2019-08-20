Pod::Spec.new do |s|
  s.name             = 'InAppMessaging'
  s.version          = '1.0.0'
  s.summary          = 'Rakuten SDK to help push notifications to mobile devices.'
  s.homepage         = 'https://confluence.rakuten-it.com/confluence/display/SSEDPT/iOS+IAM+SDK+Usage+Tutorial'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Tam' => 'daniel.a.tam@rakuten.com' }
  s.source           = { :git => 'https://gitpub.rakuten-it.com/projects/ECO/repos/ios-insights.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.1'

  s.source_files = 'InAppMessaging/Classes/**/*.{swift,h,m}'
  s.ios.vendored_frameworks = 'InAppMessaging/Frameworks/SDWebImage.framework'
  s.resource_bundle = { "InAppMessaging" => ["**/*.lproj/*.strings"] }

  s.dependency 'Swinject', "2.5.0"
end
