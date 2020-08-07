//
//  SearchResultContainerViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/06.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsContainerViewController: UIViewController {
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var appListView: UIView!
    
    var viewModel: SearchViewModel!
    var searchType: BehaviorSubject<SearchViewType>!
    private let disposeBag = DisposeBag()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history", let vc = segue.destination as? HistoryViewController {
            vc.viewModel = viewModel
            vc.searchType = searchType
        }
        if segue.identifier == "appList", let vc = segue.destination as? AppListViewController {
            vc.viewModel = viewModel
            vc.searchType = searchType
        }
    }

    private func bind() {
        searchType.subscribe(onNext: { [unowned self] in
            switch $0 {
            case .appList:
                self.view.bringSubviewToFront(self.appListView)
                break
            case .history:
                self.view.bringSubviewToFront(self.historyView)
                break
            }
        }).disposed(by: disposeBag)
    }

}
