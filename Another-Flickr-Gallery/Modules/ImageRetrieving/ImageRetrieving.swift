//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

enum ImageRetrievingError: Swift.Error {
    case cannotCreateURLFromURLConvertible
}

protocol ImageRetrieving {
    func retrieveImage(for url: URL) -> Observable<UIImage>
}

extension ImageRetrieving {
    func retrieveImage(for urlConvertible: URLConvertible?) -> Observable<UIImage> {
        guard let url = urlConvertible?.asURL() else {
            return .error(ImageRetrievingError.cannotCreateURLFromURLConvertible)
        }
        return retrieveImage(for: url)
    }
}

final class ImageRetrieverAdapter: ImageRetrieving {
    private let manager: KingfisherManager

    init(manager: KingfisherManager = KingfisherManager.shared) {
        self.manager = manager
    }

    func retrieveImage(for url: URL) -> Observable<UIImage> {
        return Observable.create { observer in
            let imageTask = self.manager.retrieveImage(with: url, options: nil, progressBlock: nil) { image, error , _, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }

                if let image = image {
                    observer.onNext(image)
                }
                observer.onCompleted()
            }

            return Disposables.create {
                imageTask.cancel()
            }
        }
    }
}
