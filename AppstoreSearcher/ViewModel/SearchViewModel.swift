//
//  SearchViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift

//private let selectedPhotosSubject = PublishSubject<UIImage>()
//var seletedPhotos: Observable<UIImage> {
//    return selectedPhotosSubject.asObserver()
//}

protocol SearchViewModellInputs {
    var history: BehaviorSubject<[String]> { get }
}

protocol SearchViewModelOutputs {
    var historySubject: Observable<[String]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModellInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelType, SearchViewModellInputs, SearchViewModelOutputs {
    var inputs: SearchViewModellInputs { return self }
    var outputs: SearchViewModelOutputs { return self }
    
    var history: BehaviorSubject<[String]>
    
    var historySubject: Observable<[String]> {
        return history.asObserver()
    }
    
    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
    }

}
