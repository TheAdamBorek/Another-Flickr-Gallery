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

    static func fake(title: String = Faker().lorem.sentence(wordsAmount: 3),
                     authorName: String = Faker().name.name(),
                     tags: [String] = [Faker().lorem.characters(amount: 1)],
                     imageURL: String = "http://lorempixel.com/200/200/",
                     createdAt: Date = Date(),
                     publishedAt: Date = Date()) -> PhotoMeta {
        return PhotoMeta(title: title, authorName: authorName, tags: tags, imageURL: imageURL, createdAt: createdAt, publishedAt: publishedAt)
    }
}
