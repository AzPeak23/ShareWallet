#
# Be sure to run `pod lib lint ShareWallet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShareWallet'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ShareWallet.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/AzPeak23/ShareWallet.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AzPeak23' => 'shahrouj@peakperformances.io' }
  s.source           = { :git => 'https://github.com/AzPeak23/ShareWallet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.source_files = ['**/*.{swift}', '**/*.{ttf}', '**/*.{strings}']
  #, '**/*.{xcframework}'
   s.resource_bundles = {
     'ShareWallet' => ['**/*.{png}', '**/*.{json}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
  s.dependency 'XLPagerTabStrip'
  s.dependency 'SwipeCellKit'
  s.dependency 'ToastViewSwift'
end
