//
//  AppListViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/08.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift
import Cosmos
import Kingfisher

class AppListViewCell: UITableViewCell {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var screenShotImageView1: UIImageView!
    @IBOutlet weak var screenShotImageView2: UIImageView!
    @IBOutlet weak var screenShotImageView3: UIImageView!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var getButton: UIButton!
    
    var viewModel: AppListViewCellViewModel?
    
    private(set) var disposeBag = DisposeBag()
    
    static let identifier = "AppListViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configuration(viewModel: AppListViewCellViewModel) {
        self.selectionStyle = .none
        if traitCollection.userInterfaceStyle == .dark {
            self.getButton.backgroundColor = UIColor.secondarySystemBackground
        }
            
        bind(viewModel: viewModel)
    }
    
    private func bind(viewModel: AppListViewCellViewModel) {
        viewModel.outputs.appSubject.subscribe(onNext: {[unowned self] app in
            self.nameLable.text = app.name
            self.genreLabel.text = app.genre
            self.ratingStar.rating = app.rating
            self.ratingCountLabel.text = String(app.ratingCount).formattingKorean()
        }).disposed(by: disposeBag)
        
        viewModel.outputs.iconImage.subscribe(onNext: { [unowned self] iconImage in
            self.appIconImageView.kf.setImage(with: iconImage)
        }).disposed(by: disposeBag)
        viewModel.outputs.screenShotImages.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] images in
            zip([self.screenShotImageView1, self.screenShotImageView2, self.screenShotImageView3], images).forEach{
                $0.0?.kf.setImage(with: $0.1)
            }
        }).disposed(by: disposeBag)
    }
}
