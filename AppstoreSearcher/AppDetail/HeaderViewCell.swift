//
//  HeaderViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift
import Cosmos

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    static let identifier = "Header"
    
    var viewModel: AppDetailViewCellViewModel?

    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(viewModel: AppDetailViewCellViewModel) {
        viewModel.outputs.appSubject.subscribe(onNext: { [unowned self] app in
            self.titleLabel.text = app.name
            self.descriptionLabel.text = app.sellerName
            self.ratingStar.rating = app.rating
            self.ratingLabel.text = String(format: "%.1f",  app.rating)
            self.ratingCountLabel.text = String(app.ratingCount)
            self.genreLabel.text = app.genre
            self.gradeLabel.text = app.grade
        }).disposed(by: disposeBag)
        viewModel.outputs.iconImage.subscribe(onNext: { [unowned self] icon in
            self.iconImageView.image = icon
        }).disposed(by: disposeBag)
    }
}
