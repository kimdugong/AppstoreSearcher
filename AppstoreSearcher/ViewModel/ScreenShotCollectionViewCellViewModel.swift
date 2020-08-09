//
//  ScreenShotCollectionViewCellViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift

protocol ScreenShotCollectionViewCellViewModelInputs {

}

protocol ScreenShotCollectionViewCellViewModelOutputs {
    var screenShotImages: Observable<[UIImage]> { get }
}

protocol ScreenShotCollectionViewCellViewModelModelType {
    var inputs: ScreenShotCollectionViewCellViewModelInputs { get }
    var outputs: ScreenShotCollectionViewCellViewModelOutputs { get }
}

struct ScreenShotCollectionViewCellViewModel: ScreenShotCollectionViewCellViewModelModelType, ScreenShotCollectionViewCellViewModelInputs, ScreenShotCollectionViewCellViewModelOutputs {
    var screenShotImages: Observable<[UIImage]>
    
    var inputs: ScreenShotCollectionViewCellViewModelInputs { return self }
    var outputs: ScreenShotCollectionViewCellViewModelOutputs { return self }
}
