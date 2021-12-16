//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkManagerProtocol {
    func request(request: NetworkRequestProtocol) -> Observable<Data>
}

class NetworkManager: NetworkManagerProtocol {
    
    private var session: URLSession!
    private let disposeBag = DisposeBag()
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30
        if #available(iOS 11, *) {
            sessionConfiguration.waitsForConnectivity = true
        }
        session = URLSession(configuration: sessionConfiguration)
    }
    
    deinit {
        session.invalidateAndCancel()
        session = nil
    }
    
    func request(request: NetworkRequestProtocol) -> Observable<Data> {
        guard let urlRequest = request.urlRequest() else {
            return Observable.error(NetworkError.badRequest("\(request)"))
        }
        
        return Observable<Data>.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NetworkError.generic)
                return Disposables.create()
            }
            
            self.session.rx.data(request: urlRequest).subscribe(onNext: { data in
                observer.onNext(data)
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
