//
//  APIManagerTests.swift
//  CurrencyConverterTests
//
//  Created by Antonio Zdelican on 16.12.21.
//

import XCTest
import RxSwift
@testable import CurrencyConverter

class APIManagerTests: XCTestCase {

    private var sut: APIManagerProtocol!
    private var mockNetworkManager: MockNetworkManager!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = APIManager(networkManager: mockNetworkManager)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_convert_withGoodRequest_shouldReturnSuccess() {
        let expectation = XCTestExpectation(description: #function)
        var response: ConvertResponse?
        let request = ConvertRequest(from: Currency.euro.rawValue, to: Currency.britishPound.rawValue, amount: 1.0)
        
        mockNetworkManager.getCorrectResponse()
        
        sut.convert(request).subscribe(onNext: { responseData in
            response = responseData
            expectation.fulfill()
        }, onError: { error in
            XCTFail("Test should not fail \(error)")
        }).disposed(by: self.disposeBag)

        XCTAssertNotNil(response)
        XCTAssertEqual(mockNetworkManager.isRequestCalled, true)
        XCTAssertEqual(mockNetworkManager.networkRequest.baseUrl, "https://my.transfergo.com/api/")
        XCTAssertEqual(mockNetworkManager.networkRequest.method, .get)
        XCTAssertEqual(response?.from, request.from)
        XCTAssertEqual(response?.to, request.to)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_convert_withBadRequest_shouldReturnError() {
        let expectation = XCTestExpectation(description: #function)
        var error: Error?
        let request = ConvertRequest(from: Currency.euro.rawValue, to: Currency.britishPound.rawValue, amount: 0.0)
        
        mockNetworkManager.getErrorResponse()
        
        sut.convert(request).subscribe(onNext: { responseData in
            XCTFail("Test should not succeed \(responseData)")
        }, onError: { responseError in
            error = responseError
            expectation.fulfill()
        }).disposed(by: self.disposeBag)

        XCTAssertNotNil(error)
        XCTAssertEqual(mockNetworkManager.isRequestCalled, true)
        XCTAssertEqual(error?.localizedDescription, "Bad request error")
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_convert_withBadResponse_shouldReturnError() {
        let expectation = XCTestExpectation(description: #function)
        var error: Error?
        let request = ConvertRequest(from: Currency.euro.rawValue, to: Currency.britishPound.rawValue, amount: 0.0)
        
        mockNetworkManager.getWrongResponse()
        
        sut.convert(request).subscribe(onNext: { responseData in
            XCTFail("Test should not succeed \(responseData)")
        }, onError: { responseError in
            error = responseError
            expectation.fulfill()
        }).disposed(by: self.disposeBag)

        XCTAssertNotNil(error)
        XCTAssertEqual(mockNetworkManager.isRequestCalled, true)
        XCTAssertEqual(error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        
        wait(for: [expectation], timeout: 10.0)
    }
}
