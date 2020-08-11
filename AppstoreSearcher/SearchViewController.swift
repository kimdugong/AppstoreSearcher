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
    
    private var viewModel: SearchViewModel!
    
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
        
        let histories = FileManager.shared.loadHistory()
        print(histories)
        viewModel = SearchViewModel(history: histories)
        
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
            DispatchQueue.main.async { [weak self] in
                if self?.children.count == 0 {
                    let appListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AppListViewController") as AppListViewController
                    appListVC.viewModel = self?.viewModel
                    self?.addChild(appListVC)
                    
                    self?.view.addSubview(appListVC.view)
                }
                self?.searchController.searchBar.text = query
                self?.searchController.searchBar.resignFirstResponder()
                self?.searchController.showsSearchResultsController = false
            }
        case .home:
            DispatchQueue.main.async { [weak self] in
                if self?.children.count ?? 0 > 0 {
                    self?.children.forEach {
                        $0.willMove(toParent: nil)
                        $0.view.removeFromSuperview()
                        $0.removeFromParent()
                    }
                }
                self?.searchController.showsSearchResultsController = false
            }
        }
    }
    
    private func bind() {
        searchController.searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: viewModel.inputs.searchText).disposed(by: disposeBag)
        searchController.searchBar.rx.searchButtonClicked.withLatestFrom(viewModel.inputs.searchText).subscribe(onNext: { [unowned self] (query) in
            self.viewModel.inputs.addHistory(with: query)
            self.viewModel.outputs.searchType.onNext(.appList(query: query))
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.showSearchResult
            .subscribe(onNext: { self.searchController.showsSearchResultsController = $0 })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.map{ _ in SearchViewType.home }.bind(to: viewModel.outputs.searchType)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .distinctUntilChanged()
            .map{ _ in true }
            .bind(to: viewModel.outputs.showSearchResult)
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchType
            .subscribe(onNext: self.transition)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(History.self).subscribe(onNext: { [unowned self] (history) in
            self.searchController.isActive = true
            self.viewModel.outputs.searchType.onNext(.appList(query: history.keyword))
            self.viewModel.inputs.requestSearch(with: history.keyword)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.historySubject
            .bind(to: tableView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, history, cell) in
            let viewModel = HistoryViewCellViewModel(history: history, searchText: self.viewModel.searchText)
            cell.configuration(viewModel: viewModel)
        }.disposed(by: disposeBag)
        
    }
    
    
}
