//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Argo
import Curry
import Runes
import RxSwift
import RxBlocking
import Moya
import Alamofire

@testable import Another_Flickr_Gallery

final class DecodableAPIClientSpec: QuickSpec {
    override func spec() {
        describe("DecodableAPIClient") {
            var subject: DecodableAPIClient!
            var apiClient: APIClientStub!

            beforeEach {
                apiClient = APIClientStub()
                subject = DecodableAPIClient(apiClient: apiClient)
            }

            describe("invoking request") {
                it("decodes single object") {
                    apiClient.jsonResponse = .just(
                            ["id": "dummyIdentifier", "name": "dummyName"]
                    )

                    let dummyObject: DummyDecodable = try! subject
                            .send(DummyRequest())
                            .toBlocking()
                            .first()!

                    expect(dummyObject.dummyIdField).to(equal("dummyIdentifier"))
                    expect(dummyObject.dummyNameField).to(equal("dummyName"))
                }

                it("decodes single object with rootKey") {
                    apiClient.jsonResponse = .just(
                            [ "rootKey": ["id": "dummyIdentifier", "name": "dummyName"] ]
                    )

                    let dummyObject: DummyDecodable = try! subject
                            .send(DummyRequest(), jsonRootKey: "rootKey")
                            .toBlocking()
                            .first()!

                    expect(dummyObject.dummyIdField).to(equal("dummyIdentifier"))
                    expect(dummyObject.dummyNameField).to(equal("dummyName"))
                }

                it("decodes array of objects") {
                    apiClient.jsonResponse = .just(
                            [ ["id": "dummyIdentifier0", "name": "dummyName0"], ["id": "dummyIdentifier1", "name": "dummyName1"] ]
                    )

                    let dummyObjects: [DummyDecodable] = try! subject.send(DummyRequest()).toBlocking().first()!

                    expect(dummyObjects[0].dummyIdField).to(equal("dummyIdentifier0"))
                    expect(dummyObjects[0].dummyNameField).to(equal("dummyName0"))

                    expect(dummyObjects[1].dummyIdField).to(equal("dummyIdentifier1"))
                    expect(dummyObjects[1].dummyNameField).to(equal("dummyName1"))
                }

                it("decodes array of objects with rootKey") {
                    let jsonArray: JSONArray = [["id": "dummyIdentifier0", "name": "dummyName0"], ["id": "dummyIdentifier1", "name": "dummyName1"]]
                    apiClient.jsonResponse = .just(
                            ["rootKey": jsonArray]
                    )

                    let dummyObjects: [DummyDecodable] = try! subject.send(DummyRequest(), jsonRootKey: "rootKey").toBlocking().first()!

                    expect(dummyObjects[0].dummyIdField).to(equal("dummyIdentifier0"))
                    expect(dummyObjects[0].dummyNameField).to(equal("dummyName0"))

                    expect(dummyObjects[1].dummyIdField).to(equal("dummyIdentifier1"))
                    expect(dummyObjects[1].dummyNameField).to(equal("dummyName1"))
                }
            }
        }
    }
}

final class DummyRequest: APIRequest {
    private(set) var path: String = ""
    private(set) var method: Moya.Method = .get
    private(set) var parameters: [String: Any]? = nil
    private(set) var parameterEncoding: ParameterEncoding = JSONEncoding()
    private(set) var validate: Bool = false
    private(set) var task: Task = .request
}

struct DummyDecodable: Decodable {
    let dummyIdField: String
    let dummyNameField: String

    static func decode(_ json: JSON) -> Decoded<DummyDecodable> {
        return curry(DummyDecodable.init)
               <^> json <| "id"
               <*> json <| "name"
    }
}
