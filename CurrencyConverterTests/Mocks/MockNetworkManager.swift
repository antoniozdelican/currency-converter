//
//  MockNetworkManager.swift
//  CurrencyConverterTests
//
//  Created by Antonio Zdelican on 16.12.21.
//

import XCTest
import RxSwift
@testable import CurrencyConverter

class MockNetworkManager: NetworkManagerProtocol {
    
    var isRequestCalled = false
    var networkRequest: NetworkRequestProtocol!
    var responseData: Data?
    var error: Error?
    
    func request(request: NetworkRequestProtocol) -> Observable<Data> {
        networkRequest = request
        isRequestCalled = true
        if let responseData = responseData {
            return Observable.just(responseData)
        } else if let error = error {
            return Observable.error(error)
        } else {
            return Observable.error(NetworkError.generic)
        }
    }

    func getCorrectResponse() {
        self.responseData = mockConvertResponseData
    }
    
    func getWrongResponse() {
        self.responseData = Data()
    }
    
    func getErrorResponse() {
        self.error = NetworkError.badRequest("Bad request error")
    }
}
