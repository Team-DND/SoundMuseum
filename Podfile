
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
pod 'Testables'

#Logging
pod 'CocoaLumberjack/Swift'

# Lint
pod 'SwiftLint'

def testable_target(name)
  target name do
    if name == 'SoundMuseum'
      #Firebase
      pod 'Firebase/Analytics'
      pod 'RxFirebase/Firestore'
      pod 'Firebase/Firestore'
      pod 'Firebase/Messaging'
      pod 'RxFirebase/Firestore'
      pod 'Google-Mobile-Ads-SDK'
      pod 'FacebookCore'
    end
    yield if block_given?

  target "#{name}Tests" do
      pod 'Quick', :binary => true
      pod 'Nimble', :binary => true
      pod 'Stubber', :binary => true
      pod 'RxTest', :binary => true
      pod 'RxBlocking', :binary => true
    end
  end
end

testable_target 'SoundMuseum'
testable_target 'DndUI'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'YES'
      if config.name == 'Debug'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
      if config.name == 'Release'
        config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
      end

      if target.name == 'RxSwift' and config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
      end
    end
  end

  at_exit {
    # carte(File.dirname(installer.pods_project.path))
    sort_project()
  }
end

# def carte(pods_dir)
#   `ruby #{pods_dir}/_Prebuild/Carte/Sources/Carte/carte.rb configure`
# end

def sort_project()
  `make sort`
end
