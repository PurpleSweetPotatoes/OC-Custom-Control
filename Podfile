# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'OCCodes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OCCodes
  pod 'AFNetworking'
  pod 'SDWebImage'
  pod 'YYModel'
  
end

install! ‘cocoapods’,
         :disable_input_output_paths => true,
         :generate_multiple_pod_projects => true,
         :incremental_installation => true

#post_install do |installer|
#  ## Must use `installer.generated_projects` instead of `installer.pods_project.targets`
#  installer.generated_projects.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['ENABLE_BITCODE'] = 'NO'
#    end
#  end
#end
