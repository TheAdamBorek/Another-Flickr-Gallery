//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
@testable import Another_Flickr_Gallery

final class FlickrImageTableViewCellSnapshotTests: SnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = true
    }

    func test_verifyTableViewCell() {
        let cell = FlickrImageTableViewCell.fromNib()
        cell.frame = CGRect(x: 0, y: 0, width: ScreenSizes.fourPointSevenInchesPhoneFrame.width, height: 290)
        cell.bind(with: SnapshotFlickrImageCellViewModel())
        verify(view: cell)
    }
}

final class SnapshotFlickrImageCellViewModel: FlickrCellViewModeling {
    let tags: String = "#landscape #see"
    let title: String = "The sample landscape"
    let authorName: String = "The author"
    let createdAt: String = "Created at 12-05-2017 13:24"
    let publishedAt: String = "Published at 12-05-2017 15:01"
    let picture: Driver<UIImage> = .just(UIImage(named: "dummy_image")!)
}
