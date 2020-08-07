//
//  AppListViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/07.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppListViewModelInputs {
}

protocol AppListViewModelOutputs {
}

protocol AppListViewModelType {
    var inputs: AppListViewModelInputs { get }
    var outputs: AppListViewModelOutputs { get }
}


struct AppListViewModel: AppListViewModelType, AppListViewModelInputs, AppListViewModelOutputs {
    
    var inputs: AppListViewModelInputs { return self }
    var outputs: AppListViewModelOutputs { return self }

    // output


    // input


    init() {

    }

}
