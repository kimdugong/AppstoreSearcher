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
    var iconImage: Observable<UIImage> { get }
    var screenShotImages: Observable<[UIImage]> { get }
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
    var iconImage: Observable<UIImage>
    var screenShotImages: Observable<[UIImage]>
    
    // input
    var app: BehaviorSubject<App>
    
    
    init(app: App) {
        self.app = BehaviorSubject<App>(value: app)
        self.iconImage = self.app.compactMap { (app) -> UIImage? in
            if let url = URL(string: app.icon), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                return image
            }
            return nil
        }.asObservable()
        self.screenShotImages = self.app.observeOn(MainScheduler.instance).compactMap{ app -> [UIImage]? in
            //            print(app.screenshots)
            //            return Array(app.screenshots.compactMap {
            //                if let url = URL(string: $0), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            //                    return image
            //                }
            //                return nil
            //            }.prefix(upTo: 3))
            let imagesArray: [UIImage] = app.screenshots.compactMap {
                if let url = URL(string: $0), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    return image
                }
                return nil
            }
            return imagesArray.count < 3 ? imagesArray : Array(imagesArray.prefix(upTo: 3))
        }
        .asObservable()
    }
    
}
