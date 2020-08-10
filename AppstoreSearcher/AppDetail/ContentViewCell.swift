//
//  ContentViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class ContentViewCell: UITableViewCell {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var whatsNewLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    static let identifier = "Content"
    
    var viewModel: AppDetailViewCellViewModel?

    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configuration(viewModel: AppDetailViewCellViewModel) {
        self.selectionStyle = .none
//        moreButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)
//        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.prominent))
//        blur.frame = moreButton.bounds
//        blur.isUserInteractionEnabled = false
//        moreButton.insertSubview(blur, at: 0)
        //        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        //        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        moreButton.setLinearGradient(leftColor: .clear, rightColor: UIColor.systemBackground, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 0.5, y: 0.5))
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: AppDetailViewCellViewModel) {
        viewModel.outputs.appSubject.subscribe(onNext: { [unowned self] app in
            self.versionLabel.text = "버전 \(app.version)"
            self.whatsNewLabel.text = app.releaseNotes
            
        }).disposed(by: disposeBag)

        moreButton.rx.tap.asDriver().drive(onNext: { Void in
            self.moreButton.isHidden = true
            self.whatsNewLabel.numberOfLines = 0
            self.whatsNewLabel.sizeToFit()
            viewModel.inputs.isMoreInfo.onNext(true)
        }).disposed(by: disposeBag)
    }
    
}
