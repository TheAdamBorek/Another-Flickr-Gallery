//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit

final class GalleryViewController: UIViewController {

    init() {
        super.init(nibName: GalleryViewController.nibName, bundle: nil)
    }

    @available(*, unavailable)
    public init?(coder aDecoder: NSCoder) {
        fatalError("init?(code: NSCoder) is not available.")
    }
}

extension GalleryViewController: NibHaving {
    static let nibName = "GalleryViewController"
}
