

Pod::Spec.new do |s|

  s.name         = "SuperQRcode"
  s.version      = "0.0.4"
  s.summary      = "二维码生成."

  s.description  = <<-DESC
	二维码生成  支持logo和换色
                   DESC

  s.homepage     = "https://github.com/Super-sweet/SuperQRcode"

  s.license      = "MIT"


  s.author       = { "Super-sweet" => "347393193@qq.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/Super-sweet/SuperQRcode.git", :tag => s.version }


  s.source_files  = "SuperQRcode/SuperQRcode*.{h,m}"
  s.frameworks    = "UIKit", "Foundation", "CoreGraphics"
  s.requires_arc  = true


end