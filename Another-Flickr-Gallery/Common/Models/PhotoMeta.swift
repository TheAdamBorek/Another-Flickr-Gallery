//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct PhotoMeta {
    let title: String
    let authorName: String
    let tags: [String]
    let imageURL: String
    let createdAt: Date
    let publishedAt: Date
}

extension PhotoMeta: Decodable {
    static func decode(_ json: JSON) -> Decoded<PhotoMeta> {
        return curry(PhotoMeta.init)
            <^> json <| "title"
            <*> (parseAuthorName <^> json <| "author")
            <*> (createTagsArray <^> json <| "tags")
            <*> json <| ["media", "m"]
            <*> (parseDate -<< json <| "date_taken")
            <*> (parseDate -<< json <| "published")
    }
}

private func parseAuthorName(string: String) -> String {
    guard let emailPrefixRange = string.range(of: "nobody@flickr.com (\""),
          let closingBracketRange = string.range(of: "\")", options: .backwards) else {
        return string
    }

    return string
        .replacingCharacters(in: closingBracketRange, with: "")
        .replacingCharacters(in: emailPrefixRange, with: "")
}

private func createTagsArray(tags: String) -> [String] {
    guard !tags.isEmpty(options: .trimBeforeChecking) else {
        return []
    }

    return tags.components(separatedBy: " ")
}

private func parseDate(string: String) -> Decoded<Date> {
    let date = ISO8601DateFormatter.iso8601Formatter.date(from: string)
    return .fromOptional(date)
}
