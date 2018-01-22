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
import Whisper

final class GalleryViewController: UIViewController {
    private enum Strings {
        static let orderByCreatedDate = NSLocalizedString("Created date", comment: "")
        static let orderByPublishDate = NSLocalizedString("Publish date", comment: "")
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = .gray
        }
    }

    @IBOutlet private weak var segmentedControl: UISegmentedControl!
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
        configureSearchBar()
        setupTranslations()
        configureDataSource()
        bindWithViewModel()
    }

    private func configureSearchBar() {
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        configureCancelSearchButtonVisibility(searchBar)
        bindSearchBarWithViewModel(searchBar)
    }

    private func configureCancelSearchButtonVisibility(_ searchBar: UISearchBar) {
        let didStartWriting = searchBar.rx.textDidBeginEditing
        let didEndWriting = searchBar.rx.textDidEndEditing
        let isEditing = Observable.of(didStartWriting.mapTo(true), didEndWriting.mapTo(false)).merge()

        isEditing.subscribe(onNext: { [unowned searchBar] isEditing in
            searchBar.setShowsCancelButton(isEditing, animated: true)
        })
            .disposed(by: rx_disposeBag)
    }

    private func bindSearchBarWithViewModel(_ searchBar: UISearchBar) {
        searchBar.rx.cancelButtonClicked
                .subscribe(onNext: { [weak searchBar] in
                    searchBar.resignFirstResponder()
                })
                .disposed(by: rx_disposeBag)

        searchBar.rx.text.orEmpty
                .bidirectionalBind(with: viewModel.tagsQuery)
                .disposed(by: rx_disposeBag)
    }

    private func setupTranslations() {
        segmentedControl.setTitle(Strings.orderByCreatedDate, forSegmentAt: 0)
        segmentedControl.setTitle(Strings.orderByPublishDate, forSegmentAt: 1)
    }

    private func configureDataSource() {
        dataSource.configureCell = { _, tableView, indexPath, cellViewModel in
            let cell: FlickrImageTableViewCell = tableView.dequeueCell(at: indexPath)
            cell.bind(with: cellViewModel)
            return cell
        }
    }

    private func bindWithViewModel() {
        bindLoadingIndicatorState()
        bindOrderBySegmenetedControl()
        bindErrorMessages()
        bindTableViewData()
    }

    private func bindLoadingIndicatorState() {
        viewModel
            .isLoading
            .filter { !$0 }
            .drive(onNext: { [refreshControl] _ in
                refreshControl?.endRefreshing()
            })
            .disposed(by: rx_disposeBag)

        viewModel
            .isLoading
            .filter { [weak self] isLoading in
                let isAnimateRefreshing = self!.refreshControl.isRefreshing ?? false
                let dontShowMainLoadingWhenRefreshingIsAnimating = !(isLoading && isAnimateRefreshing)
                return dontShowMainLoadingWhenRefreshingIsAnimating
            }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: rx_disposeBag)
    }

    private func bindOrderBySegmenetedControl() {
        viewModel
            .orderBy
            .asDriver()
            .map { order in
                switch order {
                case .byCreatedDate:
                    return 0
                case .byPublishDate:
                    return 1
                }
            }
            .drive(segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: rx_disposeBag)

        segmentedControl.rx
            .selectedSegmentIndex
            .map { (index: Int) -> GalleryOrder in
                switch index {
                case 0:
                    return .byCreatedDate
                default:
                    return .byPublishDate
                }
            }
            .bind(to: viewModel.orderBy)
            .disposed(by: rx_disposeBag)
    }

    private func bindErrorMessages() {
        viewModel
            .errorMessage
            .map { Message(title: $0, textColor: .white, backgroundColor: .red, images: nil) }
            .drive(onNext: { [weak self] message in
                guard let navigationController = self?.navigationController else { return }
                Whisper.show(whisper: message, to: navigationController, action: .show)
            })
            .disposed(by: rx_disposeBag)
    }

    private func bindTableViewData() {
        viewModel
            .photos
            .map { [GallerySectionModel(items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
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
