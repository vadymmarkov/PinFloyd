Pod::Spec.new do |s|
  s.name             = "PinFloyd"
  s.summary          = "MapKit annotations clustering for iOS."
  s.version          = "1.0.4"
  s.homepage         = "https://github.com/vadymmarkov/PinFloyd"
  s.license          = 'MIT'
  s.author           = {
    "Vadym Markov" => "markov.vadym@gmail.com"
  }
  s.source           = {
    :git => "https://github.com/vadymmarkov/PinFloyd.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/vadymmarkov'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit', 'MapKit'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
