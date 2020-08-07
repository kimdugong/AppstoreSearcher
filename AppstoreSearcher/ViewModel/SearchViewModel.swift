//
//  SearchViewModel.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/05.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelInputs {
    var searchText: BehaviorSubject<String> { get }
    var history: BehaviorSubject<[String]> { get }
    func addHistory(with query: String)
    func requestSearch(with query: String)
    var searchControllerIsActive: BehaviorSubject<Bool> { get }
}

protocol SearchViewModelOutputs {
    var filteredHistory: Observable<[String]> { get }
    var historySubject: Observable<[String]> { get }
    var appList: PublishSubject<[App]> { get }
    var searchControllerIsActiveSubject: Driver<Bool> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}


struct SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {
    var searchControllerIsActiveSubject: Driver<Bool> {
        return searchControllerIsActive.asDriver(onErrorJustReturn: false)
    }

    var appList = PublishSubject<[App]>()

    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }

    // output
    var searchControllerIsActive = BehaviorSubject<Bool>(value: false)
    var filteredHistory: Observable<[String]>
    var historySubject: Observable<[String]> {
        return history.asObserver()
    }

    // input
    var history: BehaviorSubject<[String]>
    var searchText = BehaviorSubject<String>(value: "")
    func addHistory(with query: String) {
        debugPrint("addHistory", query)
        guard let value = try? history.value() else {
            return
        }
        history.onNext([query] + value)
    }

    func requestSearch(with query: String) {
        print("requestSearch", query)
        self.appList.onNext([App(screenshotUrls: [
            "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/0f/1a/1b/0f1a1b45-f6f2-10d7-5cc0-2a4f06b8f7a0/pr_source.png/392x696bb.png",
            "https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/56/3d/90/563d90f3-c0c8-fb76-d5b6-5ba554ddf53c/pr_source.png/392x696bb.png",
            "https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/e6/3c/ec/e63cece0-e918-4f7a-dd03-18a8dd34c447/pr_source.png/392x696bb.png",
            "https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/56/f1/d2/56f1d281-2b9c-4a26-d0bb-a69501263b73/pr_source.png/392x696bb.png",
            "https://is1-ssl.mzstatic.com/image/thumb/Purple123/v4/58/d2/e8/58d2e806-f372-2303-18a0-d41bcf547fd8/pr_source.png/392x696bb.png",
            "https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/01/eb/7d/01eb7daa-4f23-9c68-e1cf-81e063ddf263/pr_source.png/392x696bb.png"
        ], description: "KPAY는 온라인 전자결제 전문기업 KG이니시스의 쉽고 빠른 간편결제입니다.\n​\n사용자가 KPAY에 신용카드/휴대폰 등의 결제정보를 미리 등록하면, 온라인 결제시 쉽고 빠르고 안전하게 결제할 수 있습니다.\n​\n[KPAY 특징]\n- 결제수단 한 번 등록으로 쉽고 빨라진 간편결제!\n- 부정거래방지시스템으로 안전하게 결제 끝!\n- 10만 가맹점에서 사용 가능한 KPAY\n​\n[필수 허용 권한]\n- 푸시 허용: PC결제시 필요하며, 가입필수값\n* 필수 권한을 허용하지 않으면, 가입이 불가합니다.\n​\n* 원활한 사용을 위해, OS는 최신버전을 권장합니다.\n​\n개발자 연락처\n - 서울시 중구 통일로 92(순화동 1-170) KG타워 14~15층\n - Tel. 1588-4954\n - e-mail. kpay@kggroup.co.kr", artworkUrl60: "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/9d/13/f1/9d13f121-e097-5bcc-01a6-07e744ec6494/source/60x60bb.jpg", averageUserRatingForCurrentVersion: 1.5789500000000000756728013584506697952747344970703125)])
        self.appList.onCompleted()
    }

    init(history: [String] = []) {
        self.history = BehaviorSubject<[String]>(value: history)
        self.filteredHistory = Observable<[String]>
            .combineLatest(self.history.asObserver(), self.searchText.asObservable()) { (history, searchText) -> [String] in
                return history.filter({ $0.prefix(searchText.count).caseInsensitiveCompare(searchText) == .orderedSame })
        }
    }

}
