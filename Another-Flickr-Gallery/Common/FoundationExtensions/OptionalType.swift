//
//  OptionalType.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 16.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation
protocol OptionalType {
    associatedtype WrappedType
    var value: WrappedType? { get }
}

extension Optional: OptionalType {
    typealias WrappedType = Wrapped

    var value: Wrapped? {
        return self
    }
}
