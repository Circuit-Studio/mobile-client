# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'circuit-studio' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Network abstraction layer written in Swift.
  pod 'Moya', '~> 10.0'
  
  # Enough said
  pod 'SwiftyJSON'
  
  # Helper functions for saving text in Keychain securely for iOS, OS X, tvOS and watchOS.
  pod 'KeychainSwift', '~> 10.0'
  
  # Ractive programming
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # UIResponder chaining
  pod 'NextResponderTextField'

  # Kingfisher is a lightweight library for downloading and caching images from the web.
  ## pod 'Kingfisher', '~> 4.0'

  # A Swift 4.0 framework for zipping and unzipping files. Simple and quick to use.
  ## source 'https://github.com/CocoaPods/Specs.git'
  ## pod 'Zip', '~> 1.1'

  target 'circuit-studioTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

  target 'circuit-studioUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
