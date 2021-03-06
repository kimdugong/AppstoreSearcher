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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        bind()
    }
    
    private func bind() {
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(History.self).subscribe(onNext: { [unowned self] history in
            debugPrint("modelSelected", history)
            self.viewModel.outputs.searchType.onNext(.appList(query: history.keyword))
            self.viewModel.inputs.requestSearch(with: history.keyword)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.filteredHistory.asObservable().bind(to: tableView.rx.items(cellIdentifier: HistoryViewCell.identifier, cellType: HistoryViewCell.self)){ [unowned self] (row, history, cell) in
            let viewModel = HistoryViewCellViewModel(history: history, searchText: self.viewModel.inputs.searchText)
            cell.configuration(viewModel: viewModel)
        }.disposed(by: disposeBag)
        
    }
}
