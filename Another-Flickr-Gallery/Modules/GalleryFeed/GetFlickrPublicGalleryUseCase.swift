//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotosMetaProviding {
    func photos(withTags tags: String) -> Observable<[PhotoMeta]>
}

final class GetFlickrPublicGalleryUseCase: PhotosMetaProviding {
    private let apiClient: DecodableAPIConnection

    init(apiClient: DecodableAPIConnection = Assembly.decodableApiClient) {
        self.apiClient = apiClient
    }

    func photos(withTags tagsQuery: String) -> Observable<[PhotoMeta]> {
        let tags = self.tags(from: tagsQuery)
        let publicFeedRequest = GetPublicFeed(tags: tags)
        return apiClient
                .send(publicFeedRequest, jsonRootKey: "itemss")
    }

    private func tags(from query: String) -> [String] {
        var tags = [String]()
        if !query.isEmpty(options: .trimBeforeChecking) {
            tags = query.components(separatedBy: " ")
        }
        return tags
    }
}
