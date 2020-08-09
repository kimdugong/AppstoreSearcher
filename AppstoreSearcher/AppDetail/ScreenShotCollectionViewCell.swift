//
//  ScreenShotCollectionViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class ScreenShotCollectionViewCell: UICollectionViewCell {
    
    let screenShotImageView = UIImageView()
    
    static let identifier = "ScreenShotCollection"
    var viewModel: AppDetailViewCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(frame.width)
        print(frame.height)
        screenShotImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 250)
        screenShotImageView.cornerRadius = 8.0
        screenShotImageView.clipsToBounds = true
        screenShotImageView.contentMode = .scaleAspectFill
        contentView.addSubview(screenShotImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: AppDetailViewCellViewModel) {

    }
    
}
