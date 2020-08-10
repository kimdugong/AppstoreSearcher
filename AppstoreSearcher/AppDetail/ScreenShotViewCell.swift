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

    func configuration(viewModel: AppDetailViewCellViewModel) {
        self.selectionStyle = .none
        bind(viewModel: viewModel)
    }

    func bind(viewModel: AppDetailViewCellViewModel) {
        screenShotCollectionView.register(ScreenShotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenShotCollectionViewCell.identifier)
        screenShotCollectionView.decelerationRate = .fast
        screenShotCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.outputs.screenShotImages.bind(to: screenShotCollectionView.rx.items(cellIdentifier: ScreenShotCollectionViewCell.identifier, cellType: ScreenShotCollectionViewCell.self)) {(row, screenshot, item) in
            item.screenShotImageView.kf.setImage(with: screenshot)
        }.disposed(by: disposeBag)
    }
}

extension ScreenShotViewCell: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.screenShotCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWithSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWithSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWithSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
}
