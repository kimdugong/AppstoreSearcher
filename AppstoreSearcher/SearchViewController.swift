//
//  ViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    
    static var sampleData: [String] = [
        "app1",
        "app2",
        "app3"
    ]
    
    private let viewModel = SearchViewModel(history: sampleData)
    
    private lazy var searchController: UISearchController = { [weak self] in
        let searchResultContainerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultContainerViewController") as SearchResultContainerViewController
        searchResultContainerViewController.viewModel = self?.viewModel
        let searchController = UISearchController(searchResultsController: searchResultContainerViewController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Games, Apps, and More"
        return searchController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.tableFooterView = UIView()
        bind()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResultsView" {
            if let destination = segue.destination as? HistoryViewController {
                destination.viewModel = viewModel
            }
        }
    }

    private func bind() {
        searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.inputs.searchText).disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked.withLatestFrom(viewModel.inputs.searchText).subscribe(onNext: { [unowned self] (query) in
            self.viewModel.inputs.addHistory(with: query)
        }).disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self).subscribe(onNext: { [unowned self] (query) in
            self.viewModel.inputs.searchControllerIsActive.onNext(true)
            self.searchController.searchBar.rx.text.onNext(query)
        }).disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

        viewModel.outputs.historySubject.bind(to: tableView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, history, cell) in
            cell.titleLabel.text = history
        }.disposed(by: disposeBag)

        viewModel.outputs.searchControllerIsActiveSubject.drive(onNext: { isActive in
            self.searchController.isActive = isActive
        }).disposed(by: disposeBag)

    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
                return
        }
    }
    
    
}
