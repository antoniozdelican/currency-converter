//
//  APIManager.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import RxSwift

protocol APIManagerProtocol {
    func convert(_ request: ConvertRequest) -> Observable<ConvertResponse>
}

class APIManager: APIManagerProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func convert(_ request: ConvertRequest) -> Observable<ConvertResponse> {
        let apiRequest = APIRequest.convert(request)
        
        return Observable<ConvertResponse>.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NetworkError.generic)
                return Disposables.create()
            }
            self.networkManager.request(request: apiRequest).subscribe(onNext: { data in
                do {
                    let convertResponse = try JSONDecoder().decode(ConvertResponse.self, from: data)
                    observer.onNext(convertResponse)
                } catch {
                    observer.onError(error)
                }
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
