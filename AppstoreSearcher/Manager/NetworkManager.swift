//
//  NetworkManager.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/07.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkMethod {
    case get
    
    var httpMethod: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

protocol NetworkModel {
    func request<T: Decodable>(url: URL, resource: String, method: NetworkMethod, params: [(String, String)]) -> Observable<T>
}

class NetworkManager: NetworkModel {
    static var shared = NetworkManager()
    private let baseURL = "https://itunes.apple.com"
    
    func request<T>(url: URL, resource: String, method: NetworkMethod, params: [(String, String)]) -> Observable<T> where T : Decodable {
        return Observable<T>.create { (observer) -> Disposable in
            var url = url
            url.appendPathComponent(resource)
            let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
            var request = URLRequest(url: url)
            
            switch method {
            case .get:
                let queryItems = params.map{ URLQueryItem(name: $0.0, value: $0.1) }
                urlComponents?.queryItems = queryItems
            }
            
            request.url = url
            request.url = urlComponents?.url
            request.httpMethod = method.httpMethod
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            debugPrint("request", request)
            return session.rx.data(request: request).map { data in
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
                }.bind(to: observer)
        }.share()
    }
    
}
