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
    var showSearchResult: BehaviorRelay<Bool> { get }
    var filteredHistory: Observable<[String]> { get }
    var historySubject: Observable<[String]> { get }
    var appList: PublishSubject<[App]> { get }
    var showLoading: BehaviorRelay<Bool> { get }
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
    var searchType = BehaviorSubject<SearchViewType>(value: .home)
    var filteredHistory: Observable<[String]>
    var historySubject: Observable<[String]> {
        return history.asObserver()
    }
    var appList = PublishSubject<[App]>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var showSearchResult: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    
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
        self.showLoading.accept(true)
        API.search(query: query)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            
            .do(afterNext: { (appList) in
                print("afterNext")
                self.showLoading.accept(false)
            },afterError: { (error) in
                print("afterError")
                self.showLoading.accept(false)
            })
            .observeOn(MainScheduler.instance)
            
            .subscribe(onNext: { (newAppList) in
                self.appList.onNext(newAppList)
            }, onError: { error in
                debugPrint(error)
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
