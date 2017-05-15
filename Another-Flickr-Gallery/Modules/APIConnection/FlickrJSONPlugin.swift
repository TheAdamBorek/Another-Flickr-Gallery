//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Moya
import Result

/**
    JSONP format is not suppored by NSJSONSerialization.
    The purpose of this plugin is to trim function name from JSONP format and parse it to JSON
    seemore: (StackOverflow: JSONP vs JSON)[http://stackoverflow.com/questions/2887209/what-are-the-differences-between-json-and-jsonp}
*/
struct JSONPNormalizationPlugin: PluginType {
    private let callbackName: String

    init(callbackName: String = "") {
        self.callbackName = callbackName + "("
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
            .map(normalizeJSONFormat)
    }

    private func normalizeJSONFormat(in response: Response) -> Response {
       return (try? response.mapString())
            .flatMap(trimClosingBracket)
            .flatMap(trimCallbackName)
            .flatMap { $0.data(using: .utf8) }
            .map { Response(statusCode: response.statusCode, data: $0, request: response.request, response: response.response) }
            ?? response
    }

    private func trimCallbackName(in json: String) -> String? {
        return json.range(of: callbackName)
            .map { json.replacingCharacters(in: $0, with: "") }
    }

    private func trimClosingBracket(in json: String) -> String? {
        return json.range(of: ")", options: .backwards)
            .map { json.replacingCharacters(in: $0, with: "") }
    }
}
