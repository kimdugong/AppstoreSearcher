//
//  AppListViewCellViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/07.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol AppListViewCellViewModelInputs {
    var app: BehaviorSubject<App> { get }
    //    func downloadImsge(url: String)
}

protocol AppListViewCellViewModelOutputs {
    var appSubject: Observable<App> { get }
    var iconImage: Observable<URL> { get }
    var screenShotImages: Observable<[URL]> { get }
}

protocol AppListViewCellViewModelType {
    var inputs: AppListViewCellViewModelInputs { get }
    var outputs: AppListViewCellViewModelOutputs { get }
}

struct AppListViewCellViewModel: AppListViewCellViewModelType, AppListViewCellViewModelInputs, AppListViewCellViewModelOutputs {
    
    var inputs: AppListViewCellViewModelInputs { return self }
    var outputs: AppListViewCellViewModelOutputs { return self }
    
    // output
    var appSubject: Observable<App> {
        return app.asObserver()
    }
    var iconImage: Observable<URL>
    var screenShotImages: Observable<[URL]>
    
    // input
    var app: BehaviorSubject<App>
    
    
    init(app: App) {
        self.app = BehaviorSubject<App>(value: app)
        self.iconImage = self.app.compactMap { (app) -> URL? in
            if let url = URL(string: app.icon) {
                return url
            }
            return nil
        }.asObservable()
        self.screenShotImages = self.app.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility)).compactMap{ app -> [URL]? in
            let imagesArray: [URL] = app.screenshots.compactMap {
                if let url = URL(string: $0) {
                    return url
                }
                return nil
            }
            return imagesArray.count < 3 ? imagesArray : Array(imagesArray.prefix(upTo: 3))
        }
        .asObservable()
    }
    
}
