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
        "app5",
        //        "app6",
        //        "app7",
        //        "app8",
        //        "app9",
        //        "app10",
        //        "app11",
        //        "app12",
        //        "app13"
    ]
    
    private var searchType = BehaviorSubject<SearchViewType>(value: .home)
    private let viewModel = SearchViewModel(history: sampleData)
    
    private lazy var searchController: UISearchController = { [weak self] in
        let historyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HistoryViewController") as HistoryViewController
        historyViewController.viewModel = self?.viewModel
        historyViewController.searchType = self?.searchType
        let searchController = UISearchController(searchResultsController: historyViewController)
        
        searchController.searchResultsUpdater = historyViewController
        
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
            //                self.navigationController?.pushViewController(appListVC, animated: false)
            let appListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AppListViewController") as AppListViewController
            appListVC.viewModel = self.viewModel
            self.searchController.searchBar.rx.text.onNext(query)
            self.searchController.searchBar.searchTextField.resignFirstResponder()
            self.addChild(appListVC)
            self.view.addSubview(appListVC.view)
            searchController.showsSearchResultsController = false
        case .home:
            //            self.navigationController?.popToRootViewController(animated: false)
            if self.children.count > 0{
                self.children.forEach {
                    $0.willMove(toParent: nil)
                    $0.view.removeFromSuperview()
                    $0.removeFromParent()
                }
            }
            searchController.showsSearchResultsController = false
        default:
            searchController.showsSearchResultsController = true
            break
        }
        
    }
    
    private func bind() {
        searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.inputs.searchText).disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked.withLatestFrom(viewModel.inputs.searchText).subscribe(onNext: { [unowned self] (query) in
            self.viewModel.inputs.addHistory(with: query)
            self.searchController.searchBar.resignFirstResponder()
            self.searchType.onNext(.appList(query: query))
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { (Void) in
        
        }).disposed(by: disposeBag)

        Observable.combineLatest(viewModel.inputs.searchText.asObserver(), searchController.searchBar.rx.textDidBeginEditing.asObservable()){ (query, _) -> SearchViewType  in
            print(query)
            if !query.isEmpty {
//                return .appList(query: query)
                return .search
            }
            return .home
            }.bind(to: searchType).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.subscribeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            self.searchType.onNext(.home)
        }).disposed(by: disposeBag)
        
        searchType.subscribeOn(MainScheduler.instance).subscribe(onNext: { (searchType) in
            self.transition(searchType: searchType)
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { [unowned self] (query) in
            //            self.viewModel.inputs.searchControllerIsActive.onNext(true)
            self.searchController.isActive = true
            self.searchType.onNext(.appList(query: query))
            self.viewModel.inputs.requestSearch(with: query)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.historySubject.bind(to: tableView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, history, cell) in
            cell.titleLabel.text = history
        }.disposed(by: disposeBag)
        
        viewModel.outputs.searchControllerIsActiveSubject.drive(onNext: { show in
//            self.searchController.isActive = isActive
        }).disposed(by: disposeBag)
    }
    
    
}
