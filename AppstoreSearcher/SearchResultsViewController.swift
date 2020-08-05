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
    private let disposeBag = DisposeBag()
    static var sampleData: [String] = [
        "app1",
        "app2",
        "app3"
    ]

    private let viewModel = SearchResultsViewModel(history: sampleData)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.filteredHistory.asObservable().bind(to: tableView.rx.items(cellIdentifier: SearchResultViewCell.identifier, cellType: SearchResultViewCell.self)){ (row, history, cell) in
            cell.titleLabel.text = history
        }.disposed(by: disposeBag)
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchBar.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)
        guard let searchText = searchController.searchBar.text else {
            return
        }
        viewModel.searchText.accept(searchText)
    }
}
