//
//  String+IsEmptyWithOptions.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 16.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation

extension String {
    enum EmptyValidationOption {
        case checkOriginal
        case trimBeforeChecking
    }

    func isEmpty(options: EmptyValidationOption = .checkOriginal) -> Bool {
        var copy = self
        if case .trimBeforeChecking = options {
            copy = copy.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return copy.isEmpty
    }
}

extension OptionalType where WrappedType == String {
    func isEmpty(options: String.EmptyValidationOption = .checkOriginal) -> Bool {
        guard let string = value else { return true }
        return string.isEmpty(options: options)
    }
}
