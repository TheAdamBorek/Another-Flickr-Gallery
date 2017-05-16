//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
protocol URLConvertible {
    func asURL() -> URL?
}

extension String: URLConvertible {
    func asURL() -> URL? {
        return URL(string: self)
    }
}
