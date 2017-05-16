//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
@testable import Another_Flickr_Gallery

final class APIClientStub: APIConnection {
    var jsonResponse: Observable<Any> = .just([:])

    func send(_ request: APIRequest) -> Observable<Any> {
        return jsonResponse
    }
}
