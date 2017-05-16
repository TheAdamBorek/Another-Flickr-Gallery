//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import NSObject_Rx
import RxBlocking

@testable import Another_Flickr_Gallery

final class GalleryViewModelSpec: QuickSpec {
    override func spec() {
        describe("GalleryViewModel") {
            var subject: GalleryViewModel!
            var photosProviderMock: PhotosProvidingMock!
            var disposeBag = DisposeBag()

            func recreateSubjectUnderTest() {
                subject = GalleryViewModel(photosProvider: photosProviderMock)
            }

            beforeEach {
                photosProviderMock = PhotosProvidingMock()
                recreateSubjectUnderTest()
            }

            afterEach {
                disposeBag = DisposeBag()
            }

            describe("photos") {
                it("asks provider for photos") {
                    subject.photos
                            .drive()
                            .disposed(by: disposeBag)
                    expect(photosProviderMock.didReceivePhotosCount).to(equal(1))
                }

                it("returns array of FlickrCellViewModel") {
                    let viewModels = try! subject.photos.toBlocking().first()!
                    viewModels.forEach {
                        expect($0).to(beAnInstanceOf(FlickrCellViewModel.self))
                    }
                }
            }

            describe("errorMessage") {
                it("sends new message when photosProvider return an error") {
                    photosProviderMock.givenPhotos = .error(NSError(domain: "dummy", code: -101))
                    let message = try! subject.errorMessage.toBlocking().first()!
                    expect(message).to(equal("Oops! An error has occurred. Try again later!"))
                }
            }
        }
    }
}

final class PhotosProvidingMock: PhotosMetaProviding {
    var didReceivePhotosCount = 0
    var givenPhotos: Observable<[PhotoMeta]> = .just(PhotoMeta.fakes(count: 5))

    var photos: Observable<[PhotoMeta]> {
        return Observable.deferred {
            self.didReceivePhotosCount += 1
            return self.givenPhotos
        }
    }
}
