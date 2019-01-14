Pod::Spec.new do |s|
  s.name         = "TravelPoints"
  s.version      = "1.0.0"
  s.summary      = "An iOS activity indicator view."
  s.description  = <<-DESC
                    TravelPoints is an iOS drop-in class that displays a translucent HUD 
                    with an indicator and/or labels while work is being done in a background thread. 
                    The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD 
                    with some additional features.
                   DESC
  s.homepage     = "https://github.com/ranjin/TravelPoints"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Charles Ran' => '244335883@qq.com' }
  s.source       = { :git => "https://github.com/ranjin/TravelPoints.git", :tag => s.version}
  s.platform     = :ios, "9.0"
  s.source_files = 'TravelPoints/*.{h,m}'
  s.requires_arc = true
end
