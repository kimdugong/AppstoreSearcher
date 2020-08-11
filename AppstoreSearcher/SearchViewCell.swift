//
//  SearchViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "SearchViewCell"
    
    var viewModel: HistoryViewCellViewModel?
    
    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configuration(viewModel: HistoryViewCellViewModel) {
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: HistoryViewCellViewModel) {
        viewModel.outputs.history.subscribe(onNext: { [unowned self] history in
            self.titleLabel.text = history.keyword
        }).disposed(by: disposeBag)
    }
}
