# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

 def rxswift
   pod 'RxSwift'
   pod 'RxCocoa'
   pod 'RxSwiftExt'
   pod 'RxDataSources'
   pod 'RxGesture'
   pod 'NSObject+Rx'
 end

target 'Another-Flickr-Gallery' do
  use_frameworks!
  inhibit_all_warnings!
  rxswift()
  pod 'Kingfisher'
  pod 'Whisper'
  pod 'Moya/RxSwift'
  pod 'Argo'
  pod 'Curry'

  target 'Another-Flickr-GalleryTests' do
    inherit! :search_paths
    inhibit_all_warnings!
    pod 'Fakery'
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Quick'
    pod 'Nimble'
  end

end
