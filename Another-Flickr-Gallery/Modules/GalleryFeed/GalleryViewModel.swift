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
    var photos: Driver<[FlickrCellViewModeling]> { get }
    var errorMessage: Driver<String> { get }
}

struct GalleryViewModel: GalleryViewModeling {
    enum Strings {
        static let generalErrorMessage = NSLocalizedString("Oops! An error has occurred. Try again later!", comment: "Unknown error message")
    }

    let photos: Driver<[FlickrCellViewModeling]>
    let errorMessage: Driver<String>

    init(photosProvider: PhotosMetaProviding = GetFlickrPublicGalleryUseCase()) {
        let photosResult = photosProvider
                .photos
                .materialize()
                .shareReplay(1)

        photos = photosResult
            .elements()
            .mapElements(FlickrCellViewModel.init)
            .asDriver(onErrorJustReturn: [])

        errorMessage = photosResult
            .errors()
            .mapTo(Strings.generalErrorMessage)
            .asDriver(onError: .ignoreError)
    }
}

protocol PhotosMetaProviding {
    var photos: Observable<[PhotoMeta]> { get }
}

struct FlickrCellViewModel: FlickrCellViewModeling {
    private let photoMeta: PhotoMeta

    init(photoMeta: PhotoMeta) {
        self.photoMeta = photoMeta
    }

    var tags: String {
         return photoMeta.tags
            .map { "#\($0)" }
            .joined(separator: " ")
    }

    var title: String {
        return photoMeta.title
    }

    var authorName: String {
        return ""
    }

    var createdAt: String {
        return "Created at \(DateFormatter.dayMonthAndTime.string(from: photoMeta.createdAt))"
    }

    var publishedAt: String {
        return "Published at \(DateFormatter.dayMonthAndTime.string(from: photoMeta.publishedAt))"
    }

    private(set) var picture: Driver<UIImage> = .never()
}
