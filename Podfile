# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'XTDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for XTDemo
  pod 'TZImagePickerController', '~> 3.8.3'
#  pod 'XLPhotoBrowser+CoderXL', '~> 1.2.0'
#  pod 'SDPhotoBrowser', '~> 0.0.3'
  
  
  
  
 post_install do |installer|
     installer.generated_projects.each do |project|
           project.targets.each do |target|
               target.build_configurations.each do |config|
                   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
                end
           end
    end
 end
  
  
end
