//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 Adam Borek. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import Argo

protocol APIRequest {
    var path: String { get }
    var method: Moya.Method { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: Moya.ParameterEncoding { get }
    var validate: Bool { get }
    var task: Task { get }
}

extension APIRequest {
    var parameters: [String: Any]? {
        return nil
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding()
    }

    var validate: Bool {
        return false
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .request
    }
}

typealias JSONArray = [[String: Any]]
protocol APIConnection {
    /**
     Sends request to the API.

    * parameter request: Request to be sent
    * returns: Observable with result of NSJSONSerialization
    */
    func send(_ request: APIRequest) -> Observable<Any>
}

final class APIClient: APIConnection {

    enum Error: Swift.Error {
        case cannotCreateBaseURL
    }

    private let provider: RxMoyaProvider<APIRequestAdapter>
    private let baseURL: URL

    init(baseURL: String, plugins: [PluginType] = []) throws {
        guard let url = URL(string: baseURL) else {
            throw Error.cannotCreateBaseURL
        }

        self.baseURL = url
        self.provider = RxMoyaProvider(plugins: plugins)
    }

    func send(_ request: APIRequest) -> Observable<Any> {
        let requestAdapter = APIRequestAdapter(baseURL: baseURL, request: request)
        return provider
                .request(requestAdapter)
                .map { try $0.mapJSON() }
    }
}

struct APIRequestAdapter: TargetType {
    let request: APIRequest
    let baseURL: URL

    init(baseURL: URL, request: APIRequest) {
        self.baseURL = baseURL
        self.request = request
    }

    var path: String {
        return request.path
    }
    var method: Moya.Method {
        return request.method
    }
    var parameters: [String: Any]? {
        return request.parameters
    }
    var parameterEncoding: ParameterEncoding {
        return request.parameterEncoding
    }
    var sampleData: Data {
        return request.sampleData
    }
    var task: Task {
        return request.task
    }
    var validate: Bool {
        return request.validate
    }
}
