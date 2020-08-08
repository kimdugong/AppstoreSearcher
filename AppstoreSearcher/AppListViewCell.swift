//
//  AppListViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/08.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class AppListViewCell: UITableViewCell {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var screenShotImageView1: UIImageView!
    @IBOutlet weak var screenShotImageView2: UIImageView!
    @IBOutlet weak var screenShotImageView3: UIImageView!
    
    var viewModel: AppListViewCellViewModel?
    
    private(set) var disposeBag = DisposeBag()
    
    static let identifier = "AppListViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(viewModel: AppListViewCellViewModel) {
        viewModel.outputs.appSubject.subscribe(onNext: {[unowned self] app in
            self.nameLable.text = app.name
            self.genreLabel.text = app.genre
        }).disposed(by: disposeBag)
        
        viewModel.outputs.iconImage.bind(to: appIconImageView.rx.image).disposed(by: disposeBag)
        viewModel.outputs.screenShotImages.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).subscribe(onNext: { [unowned self] images in
            zip([self.screenShotImageView1, self.screenShotImageView2, self.screenShotImageView3], images).forEach{
                $0.0?.image = $0.1
            }
        }).disposed(by: disposeBag)
    }
}
