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

    init(photosProvider: PhotosMetaProviding) {
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

struct PhotoMeta {
    let id: String
    let title: String
//    let tags: [String]
//    let imageURL: String
//    let createdAt: Date
//    let publishedAt: Date
}

struct FlickrCellViewModel: FlickrCellViewModeling {
    init(photoMeta: PhotoMeta) { }

    private(set) var tags: String = ""
    private(set) var title: String = ""
    private(set) var authorName: String = ""
    private(set) var createdAt: String = ""
    private(set) var publishedAt: String = ""
    private(set) var picture: Driver<UIImage> = .never()
}
