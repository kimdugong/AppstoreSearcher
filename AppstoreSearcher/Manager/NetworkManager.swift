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
    func request<T: Decodable>(url: String, resource: String, method: NetworkMethod, params: [(String, String)]) -> Observable<T>
}

class NetworkManager: NetworkModel {
    static var shared = NetworkManager()
    private let disposeBag = DisposeBag()
    let session = URLSession.shared
    
    private func requestBuilder(url: String, resource: String, method: NetworkMethod, params: [(String, String)]) -> Result<URLRequest, NetworkError> {
        guard var url = URL(string: url) else {
            return .failure(NetworkError.URLError)
        }
        
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
        
        debugPrint("request", request)
        
        return .success(request)
    }
    
    func request<T>(url: String, resource: String, method: NetworkMethod, params: [(String, String)]) -> Observable<T> where T : Decodable {
        return Observable<T>.create { (observer) -> Disposable in
            let request = self.requestBuilder(url: url, resource: resource, method: method, params: params)
            switch request {
            case .success(let request):
                self.session.rx.data(request: request).map { data -> T in
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                }.subscribe(onNext: { data in
                    observer.onNext(data)
                    observer.onCompleted()
                }, onError: { error in
                    debugPrint("url session error : ", error.localizedDescription)
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            case .failure(let error):
                observer.onError(error)
            }
            return Disposables.create()
        }.share()
    }
    
}
