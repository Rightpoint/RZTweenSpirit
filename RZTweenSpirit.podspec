Pod::Spec.new do |s|
  
  s.name         = "RZTweenSpirit"
  s.version      = "0.0.1"
  s.summary      = "A piecewise tweening/animation library for iOS."

  s.description  = <<-DESC
                   RZTweenSpirit is a lightweight, simple tweening and animation library for iOS.
                   It allows you to easily create piecewise animation timelines with precise control,
                   for things like onboarding slideshows, creative scrolling effects, and parallax.
                   DESC

  s.homepage     = "https://github.com/Raizlabs/RZTweenSpirit"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "Nick Donaldson" => "nick.donaldson@raizlabs.com", 
                           "Alex Rouse" => "alex.rouse@raizlabs.com" }
  s.social_media_url   = "http://twitter.com/raizlabs"
  
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/Raizlabs/RZTweenSpirit.git", :branch => "develop" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.requires_arc = true
  
end
