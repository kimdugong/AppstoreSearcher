//
//  API.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/07.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift

protocol ResourceModel {
    var path: String { get }
}

enum Resource: String, ResourceModel {
    var path: String {
        switch self {
        case .search:
            return "search"
        }
    }
    
    case search
}

protocol APIModel {
    static func search(query: String) -> Observable<[App]>
}

class API: APIModel {

    private static let baseURL = "https://itunes.apple.com"
    
    static func search(query: String) -> Observable<[App]> {
        guard let url = URL(string: baseURL) else {
            fatalError("unappropriated url")
        }

        let params = [("term", query), ("entity", "software"), ("country", "KR"), ("limit", "10")]

        let response: Observable<Response> = NetworkManager.shared.request(url: url, resource: Resource.search.path, method: .get, params: params)
        return response.map { $0.results }.asObservable()
    }
//    static func search(query: String) -> Observable<[App]> {
//        return Observable.create { (observer) -> Disposable in
//            guard let url = URL(string: baseURL) else {
//                fatalError("unappropriated url")
//            }
//            let params = [("term", query), ("entity", "software"), ("country", "KR"), ("limit", "10")]
//            let response: Observable<Response> = NetworkManager.shared.request(url: url, resource: Resource.search.path, method: .get, params: params)
//
//            observer.on
//
//            return Disposables.create {
//
//            }
//        }
//
//    }
    
}
