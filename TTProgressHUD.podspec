Pod::Spec.new do |s|

  s.name       = 'TTProgressHUD'
  s.version    = '0.0.6'
  s.summary    = 'TTProgressHUD is a light weight HUD written in SwiftUI meant to display the progress of an ongoing task on iOS.'
  s.author     = { 'Tobias Tiemerding' => 'info@tiemerding.com' }
  s.homepage   = 'https://tiemerding.com'

  s.license    = 'MIT' 

  s.platform = :ios, '13.0'

  s.swift_version = "5.1"

  s.source       = { :git => 'https://github.com/honkmaster/TTProgressHUD.git', :tag => s.version.to_s }

  s.source_files = 'Sources/TTProgressHUD/*.swift'

  s.dependency "SwiftUIVisualEffects", "~> 1.0.3"

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

end
