Pod::Spec.new do |s|
  s.name         = "GSFastPass"
  s.version      = "0.0.1-beta1"
  s.license      = "MIT"
  s.summary      = "Objective-C library for Get Satisfaction's FastPass authentication"
  s.homepage     = "https://github.com/satisfaction/GSFastPass"
  s.author       = { "Andrew Hite" => "ahite@getsatisfaction.com", "Nathan Speed" => "nspeed@getsatisfaction.com" }
  s.source       = { :git => "https://github.com/satisfaction/GSFastPass.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.source_files  = "GSFastPass/**/*.{h,m}"

  s.dependency "BDBOAuth1Manager", "~> 1.5"
end
