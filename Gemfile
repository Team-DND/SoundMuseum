source 'https://rubygems.org'
ruby '~> 2.6'

gem 'cocoapods', '~> 1.8'
gem 'cocoapods-binary',
  git: 'https://github.com/devxoul/cocoapods-binary.git',
  branch: 'configuration-debug-release'
gem 'fastlane', '>= 2.150.1'
gem 'slather'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)