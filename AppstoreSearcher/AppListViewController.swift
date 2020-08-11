//
//  AppListViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/06.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class AppListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var noContentView: UIView!
    @IBOutlet weak var queryLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: SearchViewModel!
    var searchType: BehaviorSubject<SearchViewType>!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appDetail", let vc = segue.destination as? AppDetailViewController {
            guard let app = sender as? App else {
                return
            }
            vc.app = app
            vc.viewModel = AppDetailViewCellViewModel(app: app)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        
        bind()
    }
    
    private func noContentItem(isEmpty: Bool) {
        if isEmpty {
            tableView.backgroundView = noContentView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    private func bind() {
        viewModel.outputs.appList.asObserver().bind(to: tableView.rx.items(cellIdentifier: AppListViewCell.identifier, cellType: AppListViewCell.self)){ (row, app, cell) in
            cell.configuration(viewModel: AppListViewCellViewModel(app: app))
        }.disposed(by: disposeBag)
        
        viewModel.outputs.appList.map { $0.count == 0 }.subscribe(onNext: { [unowned self] isEmpty in
            self.noContentItem(isEmpty: isEmpty)
        }).disposed(by: disposeBag)
        
        viewModel.inputs.searchText.map{ "'\($0)'"}.bind(to: queryLabel.rx.text).disposed(by: disposeBag)

        tableView.rx.modelSelected(App.self).subscribe(onNext: { [unowned self](app) in
            self.performSegue(withIdentifier: "appDetail", sender: app)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.showLoading.observeOn(MainScheduler.instance).map{ !$0 }.bind(to: loadingIndicator.rx.isHidden).disposed(by: disposeBag)
    }
}
