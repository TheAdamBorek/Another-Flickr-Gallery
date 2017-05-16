//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
import Moya
import Result
@testable import Another_Flickr_Gallery

final class JSONPNormalizationPluginSpec: QuickSpec {
    override func spec() {
        describe("JSONPNormalizationPlugin") {
            var subject: JSONPNormalizationPlugin!
            var originalResult: Result<Response, MoyaError>!

            beforeEach {
                subject = JSONPNormalizationPlugin(callbackName: "jsonFlickrFeed")
                let jsonp = "jsonFlickrFeed(" +
                                "{" +
                                   "\"title\":\"(dummy title)\"" +
                                "}" +
                            ")"
                let data = jsonp.data(using: .utf8)!
                let response = Response(statusCode: 200, data: data)
                originalResult = Result(value: response)
            }

            it("removes callbackName, first & last bracket from JSONP") {
                let result = subject.process(originalResult, target: DummyTargetType())
                let response = (try? result.dematerialize().mapJSON()).flatMap { $0 as? [String: Any] }
                expect(response?["title"] as? String).to(equal("(dummy title)"))
            }
        }
    }
}

struct DummyTargetType: TargetType {
    private(set) var baseURL: URL = URL(string: "https://baseurl.pl")!
    private(set) var path: String = ""
    private(set) var method: Moya.Method = .get
    private(set) var parameters: [String: Any]?
    private(set) var parameterEncoding: ParameterEncoding = JSONEncoding()
    private(set) var sampleData: Data = Data()
    private(set) var task: Task = .request
    private(set) var validate: Bool = false
}
