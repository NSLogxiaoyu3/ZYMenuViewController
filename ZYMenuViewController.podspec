Pod::Spec.new do |s|
  s.name         = 'ZYMenuViewController'
  s.version      = '0.0.2'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/NSLogxiaoyu3/ZYMenuViewController'
  s.author       = { 'NSLogxiaoyu3' => 'ideveloper_mahao@163.com' }
  s.summary      = 'a scalable side menu'
  
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = {:git => 'https://github.com/NSLogxiaoyu3/ZYMenuViewController.git', :tag => '0.0.2'}
  s.source_files = 'ZYMenuViewController'
  s.requires_arc = true
end
