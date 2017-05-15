//
//  DecodableAPIClientSpec.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 15.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation
import Argo
import RxSwift

protocol DecodableAPIConnection {
    func send<ResponseType: Decodable>(_ request: APIRequest, jsonRootKey: String?) -> Observable<ResponseType> where ResponseType.DecodedType == ResponseType
    func send<ResponseType: Decodable>(_ request: APIRequest, jsonRootKey: String?) -> Observable<[ResponseType]> where ResponseType.DecodedType == ResponseType
}

extension DecodableAPIConnection {
    func send<ResponseType: Decodable>(_ request: APIRequest) -> Observable<ResponseType> where ResponseType.DecodedType == ResponseType {
        return self.send(request, jsonRootKey: nil)
    }

    func send<ResponseType: Decodable>(_ request: APIRequest) -> Observable<[ResponseType]> where ResponseType.DecodedType == ResponseType {
        return self.send(request, jsonRootKey: nil)
    }
}

final class DecodableAPIClient: DecodableAPIConnection {
    private let apiClient: APIConnection

    convenience init(baseURL: String) throws {
        self.init(apiClient: try APIClient(baseURL: baseURL))
    }

    init(apiClient: APIConnection) {
        self.apiClient = apiClient
    }

    func send<ResponseType: Decodable>(_ request: APIRequest, jsonRootKey: String?) -> Observable<ResponseType> where ResponseType.DecodedType == ResponseType {
        return apiClient
            .send(request)
            .decode(rootKey: jsonRootKey)
    }

    func send<ResponseType: Decodable>(_ request: APIRequest, jsonRootKey: String?) -> Observable<[ResponseType]> where ResponseType.DecodedType == ResponseType {
        return apiClient
            .send(request)
            .decode(rootKey: jsonRootKey)
    }
}
