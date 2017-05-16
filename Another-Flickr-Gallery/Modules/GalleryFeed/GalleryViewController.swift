//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

final class GalleryViewController: UIViewController {
    private weak var refreshControl: UIRefreshControl!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(cell: FlickrImageTableViewCell.self)
            tableView.rowHeight = 270
            tableView.tableFooterView = UIView()
            tableView.allowsSelection = false
            configurePullToRefreshIndicator()
        }
    }

    private let viewModel: GalleryViewModeling
    private let dataSource = RxTableViewSectionedReloadDataSource<GallerySectionModel>()

    init(viewModel: GalleryViewModeling = GalleryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: GalleryViewController.nibName, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(code: NSCoder) is not available.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindWithViewModel()
    }

    private func configureDataSource() {
        dataSource.configureCell = { _, tableView, indexPath, cellViewModel in
            let cell: FlickrImageTableViewCell = tableView.dequeueCell(at: indexPath)
            cell.bind(with: cellViewModel)
            return cell
        }
    }

    private func bindWithViewModel() {
        viewModel
                .photos
                .map { [GallerySectionModel(items: $0)] }
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: rx_disposeBag)

        viewModel
                .isLoading
                .filter { !$0 }
                .drive(onNext: { [refreshControl] _ in
                    refreshControl?.endRefreshing()
                })
                .disposed(by: rx_disposeBag)
    }

    private func configurePullToRefreshIndicator() {
        let pullToRefreshControl = UIRefreshControl()
        self.refreshControl = pullToRefreshControl
        tableView.refreshControl = pullToRefreshControl

        let isRefreshing = pullToRefreshControl.rx
            .controlEvent(.valueChanged)
            .map { [unowned pullToRefreshControl] in
                return pullToRefreshControl.isRefreshing
            }


        isRefreshing
            .filter { $0 }
            .mapTo(())
            .bind(to: viewModel.didPullToRefresh)
            .disposed(by: rx_disposeBag)
    }
}

extension GalleryViewController: NibHaving {
    static let nibName = "GalleryViewController"
}

struct GallerySectionModel: SectionModelType {
    private(set) var items: [FlickrCellViewModeling] = []

    init(original: GallerySectionModel, items: [FlickrCellViewModeling]) {
        self.items = items
    }

    init(items: [FlickrCellViewModeling]) {
        self.items = items
    }
}