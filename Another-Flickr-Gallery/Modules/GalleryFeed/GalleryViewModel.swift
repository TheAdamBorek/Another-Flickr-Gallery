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

enum GalleryOrder {
    case byCreatedDate
    case byPublishDate

    func order(lhs: PhotoMeta, rhs: PhotoMeta) -> Bool {
        return orderByProperty(lhs) > orderByProperty(rhs)
    }

    private func orderByProperty(_ photo: PhotoMeta) -> Date {
        switch self {
        case .byCreatedDate:
            return  photo.createdAt
        case .byPublishDate:
            return photo.publishedAt
        }
    }
}

protocol GalleryViewModeling {
    var tagsQuery: Variable<String> { get }
    var didPullToRefresh: AnyObserver<Void> { get }

    var orderBy: Variable<GalleryOrder> { get }
    var photos: Driver<[FlickrCellViewModeling]> { get }
    var errorMessage: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
}

struct GalleryViewModel: GalleryViewModeling {
    private enum Strings {
        static let generalErrorMessage = NSLocalizedString("Oops! An error has occurred. Try again later!", comment: "Unknown error message")
    }

    let orderBy = Variable(GalleryOrder.byCreatedDate)
    let isLoading: Driver<Bool>

    let tagsQuery = Variable("")
    fileprivate let _didPullToRefresh = PublishSubject<Void>()
    private let photosResult: Observable<Event<[PhotoMeta]>>

    init(photosProvider: PhotosMetaProviding = GetFlickrPublicGalleryUseCase(),
         timeBasedActionsScheduler: SchedulerType = MainScheduler.asyncInstance) {
        let activityTracker = ActivityTracker()

        let delayedTagsQuery = tagsQuery.asObservable()
            .debounce(0.3, scheduler: timeBasedActionsScheduler)

        let photosRequest = Observable
            .of(delayedTagsQuery, _didPullToRefresh.withLatestFrom(delayedTagsQuery))
            .merge()
            .flatMapLatest { tagsQuery in
                photosProvider
                    .photos(withTags: tagsQuery)
                    .trackActivity(with: activityTracker)
                    .materialize()
            }

        let queryDidChange = tagsQuery.asObservable()
            .skip(1)

        let clearPhotosOnQueryChange: Observable<Event<[PhotoMeta]>> = queryDidChange
            .mapTo(.next([]))

        photosResult = Observable.of(photosRequest, clearPhotosOnQueryChange)
            .merge()
            .shareReplay(1)

        let startLoadingAnimationAtQueryChange: Observable<Bool> = queryDidChange.mapTo(true)
        isLoading = Observable
            .of(startLoadingAnimationAtQueryChange, activityTracker.asObservable())
            .merge()
            .distinctUntilChanged()
            .asDriver(onError: .justComplete)
    }

    var photos: Driver<[FlickrCellViewModeling]> {
        return Observable
            .combineLatest(photosResult.elements(), orderBy.asObservable()) { photos, orderBy in
                return photos.sorted(by: orderBy.order)
            }
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
