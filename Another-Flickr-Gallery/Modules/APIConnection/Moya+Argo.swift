//
//  Moya+Argo.swift
//
//  Created by Adam Borek on 15.05.2017.
//  Copyright © 2017 Adam Borek. All rights reserved.
//

import Foundation
import Argo
import RxSwift
import Moya
import Argo

extension ObservableType where E == Any {
	func decode<T: Decodable>(rootKey: String? = nil) -> Observable<T> where T == T.DecodedType {
		return map { try decodeJSON($0, rootKey: rootKey) }
	}

	func decode<T: Decodable>(rootKey: String? = nil) -> Observable<[T]> where T == T.DecodedType {
		return map { try decodeJSON($0, rootKey: rootKey) }
	}
}

private func decodeJSON<T: Decodable>(_ json: Any, rootKey: String? = nil) throws -> T where T == T.DecodedType {
    let decoded: Decoded<T>

	if let json = json as? [String: Any], let rootKey = rootKey, !rootKey.isEmpty {
        decoded = Argo.decode(json, rootKey: rootKey)
    } else {
        decoded = Argo.decode(json)
    }

	return try decoded.dematerialize()
}

private func decodeJSON<T: Decodable>(_ json: Any, rootKey: String? = nil) throws -> [T] where T == T.DecodedType {
	let decoded: Decoded<[T]>

    if let json = json as? [String: Any], let rootKey = rootKey, !rootKey.isEmpty {
		decoded = Argo.decode(json, rootKey: rootKey)
	} else {
		decoded = Argo.decode(json)
	}

	return try decoded.dematerialize()
}
