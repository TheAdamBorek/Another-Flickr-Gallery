//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation

enum Assembly {
    static let apiClient: APIConnection = {
        do {
            let plugin = JSONPNormalizationPlugin(callbackName: "jsonFlickrFeed")
            return try APIClient(baseURL: "https://api.flickr.com/", plugins: [plugin])
        } catch (let error) {
            fatalError("Cannot create apiClient: \(error)")
        }
    }()

    static let decodableApiClient: DecodableAPIConnection = {
        return DecodableAPIClient(apiClient: Assembly.apiClient)
    }()
}
