//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct FlickrCellViewModel: FlickrCellViewModeling {
    private enum Defaults {
        static let photoPlaceholder = R.image.imagePlaceholder.asImage()
    }

    private let photoMeta: PhotoMeta
    private let imageRetrieving: ImageRetrieving

    init(photoMeta: PhotoMeta, imageRetrieving: ImageRetrieving = Assembly.imageRetrieving) {
        self.photoMeta = photoMeta
        self.imageRetrieving = imageRetrieving
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

    var picture: Driver<UIImage> {
        return imageRetrieving
                .retrieveImage(for: photoMeta.imageURL, placeholder: Defaults.photoPlaceholder)
    }
}
