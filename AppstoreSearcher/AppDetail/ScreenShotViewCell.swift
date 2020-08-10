//
//  ScreenShotViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class ScreenShotViewCell: UITableViewCell {
    
    @IBOutlet weak var screenShotCollectionView: UICollectionView!
    
    var viewModel: AppDetailViewCellViewModel?

    private(set) var disposeBag = DisposeBag()
    
    static let identifier = "ScreenShot"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(viewModel: AppDetailViewCellViewModel) {
        screenShotCollectionView.register(ScreenShotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenShotCollectionViewCell.identifier)
        screenShotCollectionView.decelerationRate = .fast
        
        viewModel.outputs.screenShotImages.bind(to: screenShotCollectionView.rx.items(cellIdentifier: ScreenShotCollectionViewCell.identifier, cellType: ScreenShotCollectionViewCell.self)) {(row, screenshot, item) in
            item.screenShotImageView.kf.setImage(with: screenshot)
        }.disposed(by: disposeBag)
    }
}

extension ScreenShotViewCell: UICollectionViewDelegateFlowLayout {
    
}
