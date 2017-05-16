//
//  GalleryViewModel.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 16.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol GalleryViewModeling {
    var didPullToRefresh: AnyObserver<Void> { get }

    var photos: Driver<[FlickrCellViewModeling]> { get }
    var errorMessage: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
}

struct GalleryViewModel: GalleryViewModeling {
    private enum Strings {
        static let generalErrorMessage = NSLocalizedString("Oops! An error has occurred. Try again later!", comment: "Unknown error message")
    }

    let isLoading: Driver<Bool>
    fileprivate let _didPullToRefresh = PublishSubject<Void>()
    private let photosResult: Observable<Event<[PhotoMeta]>>

    init(photosProvider: PhotosMetaProviding = GetFlickrPublicGalleryUseCase()) {
        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()

        photosResult = _didPullToRefresh
                .startWith(())
                .flatMap {
                    photosProvider
                            .photos
                            .trackActivity(with: activityTracker)
                            .materialize()
                }
                .shareReplay(1)
    }

    var photos: Driver<[FlickrCellViewModeling]> {
        return photosResult
                .elements()
                .mapElements { FlickrCellViewModel(photoMeta: $0) }
                .asDriver(onErrorJustReturn: [])
    }

    var errorMessage: Driver<String> {
        return photosResult
                .errors()
                .mapTo(Strings.generalErrorMessage)
                .asDriver(onError: .ignoreError)
    }
}

extension GalleryViewModel {
    var didPullToRefresh: AnyObserver<Void> {
        return _didPullToRefresh.asObserver()
    }
}

protocol PhotosMetaProviding {
    var photos: Observable<[PhotoMeta]> { get }
}
