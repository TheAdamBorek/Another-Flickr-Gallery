//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift

final class GetFlickrPublicGalleryUseCase: PhotosMetaProviding {
    private let apiClient: DecodableAPIConnection

    init(apiClient: DecodableAPIConnection = Assembly.decodableApiClient) {
        self.apiClient = apiClient
    }

    var photos: Observable<[PhotoMeta]> {
        return apiClient
            .send(GetPublicFeed(), jsonRootKey: "items")
    }
}
