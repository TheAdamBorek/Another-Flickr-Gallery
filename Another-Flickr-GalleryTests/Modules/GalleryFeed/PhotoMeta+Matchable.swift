//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Nimble
@testable import Another_Flickr_Gallery

extension PhotoMeta: Equatable {
    public static func == (lhs: PhotoMeta, rhs: PhotoMeta) -> Bool {
        return lhs.title == rhs.title &&
               lhs.authorName == rhs.authorName &&
               lhs.tags == rhs.tags &&
               lhs.imageURL == rhs.imageURL &&
               lhs.createdAt == rhs.createdAt &&
               lhs.publishedAt == rhs.publishedAt
    }
}
