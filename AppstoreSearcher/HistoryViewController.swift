//
//  SearchResultsViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()

    var viewModel: SearchViewModel!
    var searchType: BehaviorSubject<SearchViewType>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        bind()
    }

    private func bind() {
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self).subscribe(onNext: { [unowned self] (query) in
            debugPrint("modelSelected", query)
            self.viewModel.inputs.requestSearch(with: query)
            self.searchType.onNext(.appList)
        }).disposed(by: disposeBag)

        viewModel.outputs.filteredHistory.asObservable().bind(to: tableView.rx.items(cellIdentifier: HistoryViewCell.identifier, cellType: HistoryViewCell.self)){ [unowned self] (row, history, cell) in
            let viewModel = HistoryViewCellViewModel(searchText: self.viewModel.inputs.searchText)
            cell.titleLabel.text = history
            cell.bind(viewModel: viewModel)
        }.disposed(by: disposeBag)

    }
}
