//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Fakery
@testable import Another_Flickr_Gallery

extension PhotoMeta: Fakable {
    static var fake: PhotoMeta {
        return PhotoMeta.fake()
    }

    static func fake(id: String = Faker().lorem.characters(amount: 20),
            title: String = Faker().lorem.sentence(wordsAmount: 3)) -> PhotoMeta {
        return PhotoMeta(id: id, title: title)
    }
}
