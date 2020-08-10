//
//  AppDetailViewCellViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol AppDetailViewCellViewModelInputs {
    var app: BehaviorSubject<App> { get }
    var isMoreInfo: BehaviorSubject<Bool> { get }
}

protocol AppDeatailViewCellViewModelOutputs {
    var appSubject: Observable<App> { get }
    var iconImage: Observable<URL> { get }
    var screenShotImages: Observable<[URL]> { get }
    var isMoreInfoSubject: Driver<Bool> { get }
}

protocol AppDetailViewCellViewModelType {
    var inputs: AppDetailViewCellViewModelInputs { get }
    var outputs: AppDeatailViewCellViewModelOutputs { get }
}

struct AppDetailViewCellViewModel: AppDetailViewCellViewModelType, AppDetailViewCellViewModelInputs, AppDeatailViewCellViewModelOutputs {

    var inputs: AppDetailViewCellViewModelInputs { return self }
    var outputs: AppDeatailViewCellViewModelOutputs { return self }
    
    // output
    var appSubject: Observable<App> {
        return app.asObserver()
    }
    var iconImage: Observable<URL>
    var screenShotImages: Observable<[URL]>
    var isMoreInfoSubject: Driver<Bool> {
        return isMoreInfo.asDriver(onErrorJustReturn: false)
    }
    
    // input
    var app: BehaviorSubject<App>
    var isMoreInfo: BehaviorSubject<Bool>
    
    init(app: App) {
        self.app = BehaviorSubject<App>(value: app)
        self.iconImage = self.app
            .compactMap { URL(string: $0.iconLarge) ?? nil }
            .asObservable()

        self.isMoreInfo = BehaviorSubject<Bool>(value: false)
        
        self.screenShotImages = self.app.observeOn(MainScheduler.instance)
            .map{ $0.screenshots.compactMap{ URL(string: $0) ?? nil } }
            .asObservable()
    }
    
}
