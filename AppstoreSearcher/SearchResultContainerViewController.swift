//
//  SearchResultContainerViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/06.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultContainerViewController: UIViewController {
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var appListView: UIView!
    
    var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history", let vc = segue.destination as? HistoryViewController {
            vc.viewModel = viewModel
        }
        if segue.identifier == "appList", let vc = segue.destination as? AppListViewController {
            vc.viewModel = viewModel
        }
    }

    private func bind() {
        viewModel.outputs.appList.subscribe(onNext: { [unowned self] appList in
            debugPrint(appList)
            if appList.isEmpty {
                self.historyView.isHidden = false
                self.appListView.isHidden = true
            } else {
                self.historyView.isHidden = true
                self.appListView.isHidden = false
            }
        }).disposed(by: disposeBag)
    }

}
