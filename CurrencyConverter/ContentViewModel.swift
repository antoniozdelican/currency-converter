//
//  ContentViewModel.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import RxSwift

class ContentViewModel: ObservableObject {
    
    @Published var fromCurrency = Currency.euro
    @Published var toCurrency = Currency.britishPound
    @Published var fromCurrencyText = String(1.0) // check if can be done better
    @Published var toCurrencyText = ""
    
    @Published var firstConversionDone = false
    @Published var isPickerShown = false
    
    let currencies: [Currency] = Currency.allCases
    
    private let apiManager: APIManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - Functions
    
    private func convert() {
        guard let amount = Float(fromCurrencyText) else { return }
        let request = ConvertRequest(from: fromCurrency.rawValue, to: toCurrency.rawValue, amount: amount)
        
        apiManager.convert(request).subscribe(onNext: { [weak self] convertResponse in
            guard let self = self else { return }
            if self.firstConversionDone == false {
                // TODO: improve this
                DispatchQueue.main.async { [weak self] in
                    self?.firstConversionDone = true
                }
            }
            print(convertResponse)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            print(error)
            // TODO: add alert
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Buttons
    
    func fromButtonTapped() {
        // TODO
    }
    
    func toButtonTapped() {
        // TODO
    }
    
    func convertButtonTapped() {
        // TODO
        convert()
    }
}
