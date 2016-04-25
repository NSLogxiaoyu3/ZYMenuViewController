Pod::Spec.new do |s|
  s.name         = "ZYMenuViewController"
  s.version      = "0.0.1"
  s.license      = "MIT"
  s.homepage     = "https://github.com/NSLogxiaoyu3/ZYMenuViewController"
  s.author       = { "NSLogxiaoyu3" => "ideveloper_mahao@163.com" }
  s.summary      = "a scalable side menu"
  
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/NSLogxiaoyu3/ZYMenuViewController.git"， :tag => "0.0.1" }
  s.source_files  = "Classes"， "ZYMenuViewController-Sample/ZYMenuViewController/*.{h，m}"
  s.public_header_files = 'ZYMenuViewController-Sample/ZYMenuViewController/*.h'
  s.requires_arc = true
end
