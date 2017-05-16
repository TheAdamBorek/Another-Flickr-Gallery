//
//  mapElements.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 16.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableConvertibleType where E: Sequence {
    func mapElements<Output>(_ transform: @escaping (E.Iterator.Element) throws -> Output) -> Observable<[Output]> {
        return self.asObservable()
            .map { elements in
                return try elements.map(transform)
        }
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: Sequence {
    func mapElements<Output>(_ transform: @escaping (E.Iterator.Element) -> Output) -> Driver<[Output]> {
        return self.asDriver()
            .map { elements in
                return elements.map(transform)
        }
    }
}
