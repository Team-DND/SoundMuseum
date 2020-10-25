# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SoundMuseum' do  
  inhibit_all_warnings!
  use_frameworks!

  platform :ios, '13.0'
  # Architecture
  pod 'ReactorKit'

  # DI
  pod 'Pure'
  pod 'Pure/Stub'
  pod 'Swinject'

  # Networking
  pod 'Moya', '14.0.0'
  pod 'Moya/RxSwift'
  pod 'MoyaSugar', '1.3.3'
  pod 'MoyaSugar/RxSwift', '1.3.3'
  
  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxTexture2'
  pod 'RxDataSources'
  pod 'RxDataSources-Texture'
  pod 'RxViewController'

  # UI
  pod 'Texture'
  pod 'BonMot'

  # Misc.
  pod 'SwiftyJSON'
  pod 'Then'

  #Logging
  pod 'CocoaLumberjack/Swift'

  #Firebase
  pod 'Firebase/Analytics'
  pod 'RxFirebase/Firestore'
  pod 'Firebase/Firestore'
  pod 'Firebase/Messaging'

  # Lint
  pod 'SwiftLint'

  target 'SoundMuseumTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'Stubber'
    pod 'RxTest'
  end
end
