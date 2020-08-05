//
//  SearchResultsViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchResultsViewModelInputs {
    var searchText: PublishRelay<String> { get }
    var history: BehaviorSubject<[String]> { get }
}

protocol SearchResultsViewModelOutputs {
    var filteredHistory: Observable<[String]> { get }
}

protocol SearchResultsViewModelType {
    var inputs: SearchResultsViewModelInputs { get }
    var outputs: SearchResultsViewModelOutputs { get }
}


class SearchResultsViewModel: SearchResultsViewModelType, SearchResultsViewModelInputs, SearchResultsViewModelOutputs {
    var inputs: SearchResultsViewModelInputs { return self }
    var outputs: SearchResultsViewModelOutputs { return self }
    
    // output
    var filteredHistory: Observable<[String]>
    // input
    var history: BehaviorSubject<[String]>
    var searchText = PublishRelay<String>()

    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
        self.filteredHistory = Observable<[String]>.combineLatest(self.history.asObserver(), self.searchText.asObservable()) { (history, searchText) -> [String] in
            return history.filter({ $0.lowercased().contains(searchText.lowercased()) })
        }
    }

}
