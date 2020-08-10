//
//  SearchResultViewCell.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    static let identifier = "HistoryViewCell"

    var viewModel: HistoryViewCellViewModel?

    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(viewModel: HistoryViewCellViewModel) {
        viewModel.outputs.searchTextSubject.drive(onNext: { [unowned self] searchText in
            self.titleLabel.attributedText = self.setHighlight(labelText: self.titleLabel.text, highlited: searchText)
        }).disposed(by: disposeBag)
    }

    private func setHighlight(labelText: String?, highlited: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 21),
            .foregroundColor: UIColor.secondaryLabel
        ]

        let attributedString = NSAttributedString(
            string: labelText?.lowercased() ?? "",
            attributes: attributes
        )

        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )

        mutableAttributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.label,
            range: mutableAttributedString.mutableString.range(of: highlited.lowercased()))
        return mutableAttributedString
    }

}
