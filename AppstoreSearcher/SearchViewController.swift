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
        "카카오",
        "app2",
        "app3",
        "app4",
        "app5"
    ]
    
    private let viewModel = SearchViewModel(history: sampleData)
    
    private lazy var searchController: UISearchController = { [weak self] in
        let historyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HistoryViewController") as HistoryViewController
        historyViewController.viewModel = self?.viewModel
        let searchController = UISearchController(searchResultsController: historyViewController)
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Games, Apps, and More"
        searchController.searchBar.autocapitalizationType = .none
        return searchController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        
        tableView.tableFooterView = UIView()
        bind()
    }
    
    private func transition(searchType: SearchViewType) {
        switch searchType {
        case .appList(let query):
            let appListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AppListViewController") as AppListViewController
            appListVC.viewModel = self.viewModel
            self.searchController.searchBar.text = query
            self.addChild(appListVC)
            self.view.addSubview(appListVC.view)
            DispatchQueue.main.async { [weak self] in
                self?.searchController.searchBar.resignFirstResponder()
                self?.searchController.showsSearchResultsController = false
            }
        case .home:
            if self.children.count > 0 {
                self.children.forEach {
                    $0.willMove(toParent: nil)
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.searchController.showsSearchResultsController = false
            }
        case .search:
            searchController.showsSearchResultsController = true
            break
        }
        
    }
    
    private func bind() {
        searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.inputs.searchText).disposed(by: disposeBag)
        searchController.searchBar.rx.searchButtonClicked.withLatestFrom(viewModel.inputs.searchText).subscribe(onNext: { [unowned self] (query) in
            self.viewModel.inputs.addHistory(with: query)
            self.viewModel.outputs.searchType.onNext(.appList(query: query))
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: { [unowned self] _ in
            self.viewModel.outputs.searchType.onNext(.home)
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.changed.subscribe(onNext: { (query) in
            if query == "" {
                self.viewModel.outputs.searchType.onNext(.home)
            }
            self.viewModel.outputs.searchType.onNext(.search)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.searchType.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: self.transition)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { [unowned self] (query) in
            self.searchController.isActive = true
            self.viewModel.outputs.searchType.onNext(.appList(query: query))
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.historySubject.bind(to: tableView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, history, cell) in
            let viewModel = HistoryViewCellViewModel(history: history, searchText: self.viewModel.searchText)
            cell.configuration(viewModel: viewModel)
        }.disposed(by: disposeBag)
        
    }
    
    
}
