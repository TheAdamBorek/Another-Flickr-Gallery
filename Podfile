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
  rxswift()
  pod 'Kingfisher'
  pod 'Whisper'

  target 'Another-Flickr-GalleryTests' do
    inherit! :search_paths
    pod 'Fakery'
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Quick'
    pod 'Nimble'
  end

end
