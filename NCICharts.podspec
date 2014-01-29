Pod::Spec.new do |s|

  s.name         = 'NCICharts'
  s.version      = '1.0.0'
  s.summary      = 'Simple, zoom, dynamic and charts with ranges for iOS'

  s.description  = <<-DESC
  Simple, zoom, dynamic and charts with ranges for iOS
                   DESC
  s.license      = {:type => 'Apache'}
  s.homepage     = 'https://github.com/FlowForwarding/dynamiccharts'
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
  s.source       = { :git => 'git@github.com:FlowForwarding/dynamiccharts.git'}

  s.source_files = 'NCIChart/**/*.{h,m}'
  s.ios.framework = 'CoreFoundation'

end