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
    var searchTextSubject: Driver<String> { get }
}

protocol HistoryViewCellViewModelType {
    var inputs: HistoryViewCellViewModelInputs { get }
    var outputs: HistoryViewCellViewModelOutputs { get }
}

struct HistoryViewCellViewModel: HistoryViewCellViewModelType, HistoryViewCellViewModelInputs, HistoryViewCellViewModelOutputs {

    var inputs: HistoryViewCellViewModelInputs { return self }
    var outputs: HistoryViewCellViewModelOutputs { return self }

    // output
    var searchTextSubject: Driver<String> {
        return searchText.asDriver(onErrorJustReturn: "")
    }
    // input
    var searchText: BehaviorSubject<String>

}
