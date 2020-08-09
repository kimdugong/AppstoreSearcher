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
    //    func downloadImsge(url: String)
}

protocol AppDeatailViewCellViewModelOutputs {
    var appSubject: Observable<App> { get }
    var iconImage: Observable<UIImage> { get }
    var screenShotImages: Observable<[UIImage]> { get }
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
    var iconImage: Observable<UIImage>
    var screenShotImages: Observable<[UIImage]>
    
    // input
    var app: BehaviorSubject<App>
    
    
    init(app: App) {
        self.app = BehaviorSubject<App>(value: app)
        self.iconImage = self.app.compactMap { (app) -> UIImage? in
            if let url = URL(string: app.iconLarge), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                return image
            }
            return nil
        }.asObservable()
        
        self.screenShotImages = self.app.observeOn(MainScheduler.instance).compactMap{ app -> [UIImage]? in
            return app.screenshots.compactMap {
                if let url = URL(string: $0), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    return image
                }
                return nil
            }
        }
        .asObservable()
    }
    
}
