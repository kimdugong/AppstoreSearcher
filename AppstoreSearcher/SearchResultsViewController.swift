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

    let viewModel = SearchResultsViewModel(history: sampleData)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        viewModel.searchText.subscribe(onNext: { (searchText) in
            print(searchText)
        })
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = viewModel.history[indexPath.row]

        return cell
    }


}

extension SearchResultsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)
    }
}
