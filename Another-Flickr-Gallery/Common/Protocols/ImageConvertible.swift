//
//  ImageConvertible.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 16.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit
import Rswift

protocol UIImageConvertible {
    func asImage() -> UIImage
}

extension ImageResource: UIImageConvertible {
    func asImage() -> UIImage {
        guard let image = UIImage(resource: self, compatibleWith: nil) else {
            assertionFailure("Cannot load image from R.swift! o.O. It shouldn't happen")
            return UIImage()
        }
        return image
    }
}
