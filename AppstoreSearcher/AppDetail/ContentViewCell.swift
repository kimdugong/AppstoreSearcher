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
    
    func bind(viewModel: AppDetailViewCellViewModel) {
        viewModel.outputs.appSubject.subscribe(onNext: { [unowned self] app in
            self.versionLabel.text = "버전 \(app.version)"
            self.whatsNewLabel.text = app.releaseNotes
            
        }).disposed(by: disposeBag)
    }
    
}
