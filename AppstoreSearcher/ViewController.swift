//
//  ViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var searchController: UISearchController = {
        let searchResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultsViewController")
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.placeholder = "Games, Apps, and More"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }


}

