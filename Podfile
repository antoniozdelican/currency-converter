# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

def shared_pods
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'CurrencyConverter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CurrencyConverter
  shared_pods

  target 'CurrencyConverterTests' do
    inherit! :search_paths
    shared_pods
  end

end
