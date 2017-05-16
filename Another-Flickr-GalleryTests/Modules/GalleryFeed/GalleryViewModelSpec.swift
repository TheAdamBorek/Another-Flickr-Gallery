//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
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

            describe("pull to refresh") {
                it("forces a refresh of photos") {
                    let testScheduler = TestScheduler(initialClock: 0)
                    photosProviderMock.givenPhotos = testScheduler.createColdObservable([next(100, [PhotoMeta.fake]), completed(100)]).asObservable()
                    let observer = testScheduler.createObserver([FlickrCellViewModeling].self)

                    subject.photos.drive(observer).disposed(by: disposeBag)

                    testScheduler.scheduleAt(200) {
                        subject.didPullToRefresh.onNext(())
                    }
                    testScheduler.start()

                    expect(observer.events.map { $0.time }) == [100, 300]
                }
            }

            describe("isLoading") {
                it("indicates if there is any action ongoing") {
                    let testScheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
                    photosProviderMock.givenPhotos = testScheduler.createColdObservable([next(100, [PhotoMeta.fake]), completed(100)]).asObservable()
                    driveOnScheduler(testScheduler) { recreateSubjectUnderTest() }

                    let observer = testScheduler.createObserver(Bool.self)
                    subject.photos.drive().disposed(by: disposeBag)

                    subject.isLoading.drive(observer).disposed(by: disposeBag)
                    testScheduler.start()

                    XCTAssertEqual(observer.events, [
                        next(0, true),
                        next(100, false)
                        ])
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
