Pod::Spec.new do |s|

  s.name         = 'NCICharts'
  s.version      = '1.0.0'
  s.summary      = 'Simple, zoom and charts with ranges for iOS'

  s.description  = <<-DESC
  Linear charts and charts with range selectors
                   DESC
  s.license      = {:type => 'Apache'}
  s.homepage     = 'https://github.com/FlowForwarding/tapestry/tree/master/src/ui/mobile/ios/Tapestry/NCIChart'
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
  s.source       = { :git => 'git@github.com:FlowForwarding/tapestry.git'}

  s.source_files = 'src/ui/mobile/ios/Tapestry/NCIChart/NCIChart/**/*.{h,m}'
  s.ios.framework = 'CoreFoundation'

end
