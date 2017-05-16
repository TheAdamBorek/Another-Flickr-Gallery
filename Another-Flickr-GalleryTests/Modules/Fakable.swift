//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation

protocol Fakable {
    static var fake: Self { get }
}

extension Fakable {
    static func fakes(count: Int = 5) -> [Self] {
        var array = [Self]()
        for _ in 0..<count {
            array.append(Self.fake)
        }
        return array
    }
}
