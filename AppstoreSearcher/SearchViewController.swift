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
    
    private var searchController: UISearchController = {
        let searchResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultsViewController")
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchResultsUpdater = searchResultViewController as? UISearchResultsUpdating
        searchController.searchBar.placeholder = "Games, Apps, and More"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.tableFooterView = UIView()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.historySubject.bind(to: tableView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, history, cell) in
            cell.titleLabel.text = history
        }.disposed(by: disposeBag)
        
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerLabel: UILabel = {
//           let label = UILabel()
//            label.text = "최근 검색어"
//            label.font = UIFont.boldSystemFont(ofSize: 20)
//            return label
//        }()
//        
//        NSLayoutConstraint.activate([
//            headerLabel.heightAnchor.constraint(equalToConstant: 1000)
//        ])
//        return headerLabel
//        
//    }
}
