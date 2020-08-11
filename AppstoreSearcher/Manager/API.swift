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
        let params = [("term", query), ("entity", "software"), ("country", "KR"), ("limit", "50")]
        let response: Observable<Response> = NetworkManager.shared.request(url: baseURL, resource: Resource.search.path, method: .get, params: params)
        
        return response.map{ $0.results }.asObservable()
    }
    
}
