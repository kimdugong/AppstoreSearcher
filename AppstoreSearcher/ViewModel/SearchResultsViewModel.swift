//
//  SearchResultsViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxCocoa

class SearchResultsViewModel {

    var history: [String]
    let searchText = PublishRelay<String?>()

    init(history: [String] = []) {
        self.history = history
    }

}
