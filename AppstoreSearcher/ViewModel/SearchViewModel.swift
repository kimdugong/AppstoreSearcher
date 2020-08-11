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

protocol SearchViewModelInputs {
    var searchText: BehaviorSubject<String> { get }
    var history: BehaviorSubject<[String]> { get }
    func addHistory(with query: String)
    func requestSearch(with query: String)
}

protocol SearchViewModelOutputs {
    var searchType: BehaviorSubject<SearchViewType> { get }
    var filteredHistory: Observable<[String]> { get }
    var historySubject: Observable<[String]> { get }
    var appList: PublishSubject<[App]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}


struct SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {
    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }
    
    let disposeBag = DisposeBag()
    
    // output
    internal var searchType = BehaviorSubject<SearchViewType>(value: .home)
    internal var filteredHistory: Observable<[String]>
    internal var historySubject: Observable<[String]> {
        return history.asObserver()
    }
    internal var appList = PublishSubject<[App]>()
    
    
    // input
    internal var history: BehaviorSubject<[String]>
    internal var searchText = BehaviorSubject<String>(value: "")
    internal func addHistory(with query: String) {
        debugPrint("addHistory", query)
        guard let value = try? history.value() else {
            return
        }
        history.onNext([query] + value)
    }
    internal func requestSearch(with query: String) {
        debugPrint("requestSearch", query)
        API.search(query: query).subscribe(onNext: { (newAppList) in
            self.appList.onNext(newAppList)
        }).disposed(by: disposeBag)
    }
    
    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
        self.filteredHistory = Observable<[String]>
            .combineLatest(self.history, self.searchText) { (history, searchText) -> [String] in
                return history.filter({ $0.prefix(searchText.count).caseInsensitiveCompare(searchText) == .orderedSame })
        }
    }
    
}
