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
    var didChangeTagsQuery: AnyObserver<String> { get }
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

    fileprivate let _didChangeTagsQuery = PublishSubject<String>()
    fileprivate let _didPullToRefresh = PublishSubject<Void>()
    private let photosResult: Observable<Event<[PhotoMeta]>>

    init(photosProvider: PhotosMetaProviding = GetFlickrPublicGalleryUseCase()) {
        let activityTracker = ActivityTracker()

        let delayedTagsQuery = _didChangeTagsQuery
            .debounce(0.3, scheduler: MainScheduler.instance)

        let photosRequest = Observable
            .of(delayedTagsQuery, _didPullToRefresh.mapTo(""))
            .merge()
            .startWith("")
            .flatMapLatest { tagsQuery in
                photosProvider
                    .photos(withTags: tagsQuery)
                    .trackActivity(with: activityTracker)
                    .materialize()
            }

        let clearPhotosOnQueryChange: Observable<Event<[PhotoMeta]>> = _didChangeTagsQuery.mapTo(.next([]))

        photosResult = Observable.of(photosRequest, clearPhotosOnQueryChange)
            .merge()
            .shareReplay(1)

        let startLoadingAnimationAtQueryChange: Observable<Bool> = _didChangeTagsQuery.mapTo(true)
        isLoading = Observable
            .of(startLoadingAnimationAtQueryChange, activityTracker.asObservable())
            .merge()
            .distinctUntilChanged()
            .asDriver(onError: .justComplete)
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

    var didChangeTagsQuery: AnyObserver<String> {
        return _didChangeTagsQuery.asObserver()
    }
}
