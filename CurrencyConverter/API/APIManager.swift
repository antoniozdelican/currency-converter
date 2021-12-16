//
//  APIManager.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import RxSwift

protocol APIManagerProtocol {
    func convert(_ request: ConvertRequest) -> Observable<Data> // for now until I see what's the response
}

class APIManager: APIManagerProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func convert(_ request: ConvertRequest) -> Observable<Data> {
        let apiRequest = APIRequest.convert(request)
        
        // TODO: change this to ConvertResponse
        return Observable<Data>.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NetworkError.generic)
                return Disposables.create()
            }
            self.networkManager.request(request: apiRequest).subscribe(onNext: { data in
                // TODO: change this to ConvertResponse
                observer.onNext(data)
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
