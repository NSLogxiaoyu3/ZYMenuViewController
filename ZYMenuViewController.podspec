Pod::Spec.new do |s|
  s.name         = "ZYMenuViewController"
  s.version      = "0.0.1"
  s.summary      = "a scalable side menu"
  s.description  = <<-DESC
                      this project provide a scalable side menu for iOS developer 
                   DESC
  s.homepage     = "https://github.com/NSLogxiaoyu3/ZYMenuViewController"
  s.license      = "MIT"
  s.license      = { :type => "MIT"， :file => "LICENSE" }
  s.author             = { "NSLogxiaoyu3" => "ideveloper_163@163.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/NSLogxiaoyu3/ZYMenuViewController.git"， :tag => "0.0.1" }
  s.source_files  = "Classes"， "ZYMenuViewController-Sample/ZYMenuViewController/*.{h，m}"
  s.requires_arc = true
end
