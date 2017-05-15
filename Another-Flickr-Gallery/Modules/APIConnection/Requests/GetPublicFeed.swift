//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Moya
//import Alamofire

struct GetPublicFeed: APIRequest {
    var path: String {
        return "services/feeds/photos_public.gne"
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return [
            "format": "json"
        ]
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
}
