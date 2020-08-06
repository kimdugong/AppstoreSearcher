//
//  SearchViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//internal protocol SearchViewModellInputs {
//    var history: BehaviorSubject<[String]> { get }
//}
//
//internal protocol SearchViewModelOutputs {
//    var historySubject: Observable<[String]> { get }
//}
//
//internal protocol SearchViewModelType {
//    var inputs: SearchViewModellInputs { get }
//    var outputs: SearchViewModelOutputs { get }
//}
//
//class SearchViewModel: SearchViewModelType, SearchViewModellInputs, SearchViewModelOutputs {
//    var inputs: SearchViewModellInputs { return self }
//    var outputs: SearchViewModelOutputs { return self }
//    
//    var history: BehaviorSubject<[String]>
//    
//    var historySubject: Observable<[String]> {
//        return history.asObserver()
//    }
//    
//    init(history: [String] = []) {
//        self.history = BehaviorSubject<[String]>(value: history)
//    }
//
//}

protocol SearchViewModellInputs {
    var searchText: PublishRelay<String> { get }
    var history: BehaviorSubject<[String]> { get }
    func addHistory(with query: String)
}

protocol SearchViewModelOutputs {
    var filteredHistory: Observable<[String]> { get }
    var historySubject: Observable<[String]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModellInputs { get }
    var outputs: SearchViewModelOutputs { get }
}


class SearchViewModel: SearchViewModelType, SearchViewModellInputs, SearchViewModelOutputs {
    var inputs: SearchViewModellInputs { return self }
    var outputs: SearchViewModelOutputs { return self }

    // output
    var filteredHistory: Observable<[String]>
    var historySubject: Observable<[String]> {
        return history.asObserver()
    }

    // input
    var history: BehaviorSubject<[String]>
    var searchText = PublishRelay<String>()
    func addHistory(with query: String) {
        debugPrint("addHistory", query)
        guard let value = try? history.value() else {
            return
        }
        history.onNext(value + [query])
    }

    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
        self.filteredHistory = Observable<[String]>
            .combineLatest(self.history.asObserver(), self.searchText.asObservable()) { (history, searchText) -> [String] in
            return history.filter{ $0.lowercased().contains(searchText.lowercased()) }
        }
    }

}
