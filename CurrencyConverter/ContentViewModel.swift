//
//  ContentViewModel.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var fromCurrency = Currency.euro
    @Published var toCurrency = Currency.britishPound
    @Published var fromCurrencyText = String(1.0) // check if can be done better
    @Published var toCurrencyText = ""
    
    @Published var firstConversionDone = false
    @Published var isPickerShown = false
    
    let currencies: [Currency] = Currency.allCases
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - Functions
    
    private func convert() {
        // TODO: network call
        if firstConversionDone == false { firstConversionDone = true }
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
