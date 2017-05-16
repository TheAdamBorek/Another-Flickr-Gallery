//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol FlickrCellViewModeling {
    var tags: String { get }
    var title: String { get }
    var authorName: String { get }
    var createdAt: String { get }
    var publishedAt: String { get }
    var picture: Driver<UIImage> { get }
}

final class FlickrImageTableViewCell: RxTableViewCell {
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var publishedAtLabel: UILabel!
    @IBOutlet private weak var pictureView: UIImageView!

    func bind(with viewModel: FlickrCellViewModeling) {
        bindConstantValues(from: viewModel)
        bindObservableValues(from: viewModel)
    }

    private func bindConstantValues(from viewModel: FlickrCellViewModeling) {
        tagsLabel.text = viewModel.tags
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.authorName
        createdAtLabel.text = viewModel.createdAt
        publishedAtLabel.text = viewModel.publishedAt
    }

    private func bindObservableValues(from viewModel: FlickrCellViewModeling) {
        viewModel.picture
            .drive(pictureView.rx.image)
            .disposed(by: rx_disposeBag)
    }

}

extension FlickrImageTableViewCell: NibHaving {
    static let nibName = "FlickrImageTableViewCell"
}
