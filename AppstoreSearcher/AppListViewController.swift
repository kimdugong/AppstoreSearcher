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
    var viewModel: SearchViewModel!
    var searchType: BehaviorSubject<SearchViewType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
