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
    var searchControllerIsActive: BehaviorSubject<Bool> { get }
}

protocol SearchViewModelOutputs {
    var filteredHistory: Observable<[String]> { get }
    var historySubject: Observable<[String]> { get }
    var appList: PublishSubject<[App]> { get }
    var searchControllerIsActiveSubject: Driver<Bool> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}


struct SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {
    var searchControllerIsActiveSubject: Driver<Bool> {
        return searchControllerIsActive.asDriver(onErrorJustReturn: false)
    }

    var appList = PublishSubject<[App]>()

    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }
    
    let disposeBag = DisposeBag()

    // output
    var searchControllerIsActive = BehaviorSubject<Bool>(value: false)
    var filteredHistory: Observable<[String]>
    var historySubject: Observable<[String]> {
        return history.asObserver()
    }

    // input
    var history: BehaviorSubject<[String]>
    var searchText = BehaviorSubject<String>(value: "")
    func addHistory(with query: String) {
        debugPrint("addHistory", query)
        guard let value = try? history.value() else {
            return
        }
        history.onNext([query] + value)
    }

    func requestSearch(with query: String) {
        debugPrint("requestSearch", query)
        API.search(query: query).subscribe(onNext: { (newAppList) in
            self.appList.onNext(newAppList)
        }).disposed(by: disposeBag)
    }

    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
        self.filteredHistory = Observable<[String]>
            .combineLatest(self.history.asObserver(), self.searchText.asObservable()) { (history, searchText) -> [String] in
                return history.filter({ $0.prefix(searchText.count).caseInsensitiveCompare(searchText) == .orderedSame })
        }
    }

}
