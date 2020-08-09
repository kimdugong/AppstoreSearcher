//
//  AppDetailViewController.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/09.
//  Copyright © 2020 dugong. All rights reserved.
//

import UIKit
import RxSwift

class AppDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var app: App?
    var viewModel: AppDetailViewCellViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: HeaderViewCell.identifier)
        tableView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellReuseIdentifier: ContentViewCell.identifier)
        tableView.register(UINib(nibName: "ScreenShotViewCell", bundle: nil), forCellReuseIdentifier: ScreenShotViewCell.identifier)
        
        viewModel.outputs.appSubject.map{ [$0, $0] }.subscribe { (app) in
            print(app)
        }.disposed(by: disposeBag)
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.titleView = nil
    }
    
    private func bind() {
//        viewModel.outputs.appSubject.bind(to: tableView.rx.items){ (tableView, row, app) -> UITableViewCell in
//            return UITableViewCell()
//        }
        viewModel.outputs.appSubject.map{ [$0, $0, $0] }.bind(to: tableView.rx.items) { [unowned self](tv, row, app) in
            if row == 0 {
                guard let cell = tv.dequeueReusableCell(withIdentifier: "Header", for: IndexPath(row: row, section: 0)) as? HeaderViewCell else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: self.viewModel)
                return cell
            }
            
            if row == 1 {
                guard let cell = tv.dequeueReusableCell(withIdentifier: "Content", for: IndexPath(row: row, section: 0)) as? ContentViewCell else {
                    return UITableViewCell()
                }
                
                cell.whatsNewLabel.text = ";alsdfj;aoisdfja;oidsfj;adfsja;ldksfja;lkdfa;ldsfkja;lkdjfa;ldskfj;alksdfjal;dksfjla;kdsfjl;akdsjf;laksdfj ;akldfj;aldkfs;alkdsfj;aldksfja;sdflkjads;lkfja;lsdkfj"
                return cell
            }
            
            if row == 2 {
                guard let cell = tv.dequeueReusableCell(withIdentifier: "ScreenShot") as? ScreenShotViewCell else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: self.viewModel)
                return cell
            }
            
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
    }
    

}
