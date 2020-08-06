//
//  SearchResultsViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appListView: UIView!
    private let disposeBag = DisposeBag()

    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
//        viewModel.inputs.searchText.subscribe(onNext: { (query) in
//            debugPrint("searchText", query)
//        }).disposed(by: disposeBag)

        bind()
    }

    private func bind() {
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self).subscribe(onNext: { [unowned self] (query) in
            debugPrint("modelSelected", query)
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)

        viewModel.outputs.filteredHistory.asObservable().bind(to: tableView.rx.items(cellIdentifier: SearchResultViewCell.identifier, cellType: SearchResultViewCell.self)){ (row, history, cell) in
            cell.titleLabel.text = history
        }.disposed(by: disposeBag)

        viewModel.outputs.appList.subscribe(onNext: { [unowned self] appList in
            debugPrint(appList)
            self.appListView.isHidden = false
        }).disposed(by: disposeBag)

    }
}

//extension SearchResultsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}

//extension SearchResultsViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        //        searchController.searchBar.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)
//        guard let searchText = searchController.searchBar.text else {
//            return
//        }
//        viewModel.searchText.accept(searchText)
//    }
//}
