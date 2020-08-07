//
//  HistoryViewCellViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/07.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol HistoryViewCellViewModelInputs {
    var searchText: BehaviorSubject<String> { get }
}

protocol HistoryViewCellViewModelOutputs {
    var searchTextSubject: Observable<String> { get }
}

protocol HistoryViewCellViewModelType {
    var inputs: HistoryViewCellViewModelInputs { get }
    var outputs: HistoryViewCellViewModelOutputs { get }
}

struct HistoryViewCellViewModel: HistoryViewCellViewModelType, HistoryViewCellViewModelInputs, HistoryViewCellViewModelOutputs {

    var inputs: HistoryViewCellViewModelInputs { return self }
    var outputs: HistoryViewCellViewModelOutputs { return self }

    // output
    var searchTextSubject: Observable<String> {
        return searchText.asObservable()
    }
    // input
    var searchText: BehaviorSubject<String>

}
