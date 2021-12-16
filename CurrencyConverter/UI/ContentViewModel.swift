//
//  ContentViewModel.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import RxSwift

enum FocusedTextFieldType {
    case from, to, none
}

class ContentViewModel: ObservableObject {
    
    @Published var fromCurrency = Currency.euro {
        didSet {
            currencySelectionChanged()
        }
    }
    @Published var toCurrency = Currency.britishPound {
        didSet {
            currencySelectionChanged()
        }
    }
    @Published var fromCurrencyText = String(1.0) // check if can be done better
    @Published var toCurrencyText = ""
    @Published var rateText = ""
    
    @Published var firstConversionDone = false
    
    @Published var currencyPickerType = CurrencyPickerType.from
    @Published var focusedTextFieldType = FocusedTextFieldType.from
    @Published var isPickerShown = false
    
    @Published var isErrorAlertShown = false
    @Published var errorMessage = ""
    
    let currencies: [Currency] = Currency.allCases
    
    private let apiManager: APIManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - Functions
    
    private func convert(fromCurrency: Currency, toCurrency: Currency, amountText: String) {
        guard let amount = Float(amountText) else { return }
        let request = ConvertRequest(from: fromCurrency.rawValue, to: toCurrency.rawValue, amount: amount)
        
        apiManager.convert(request).subscribe(onNext: { [weak self] convertResponse in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.firstConversionDone == false { self.firstConversionDone = true }
                
                switch self.focusedTextFieldType {
                case .from,
                     .none:
                    self.toCurrencyText = String(convertResponse.fromAmount * convertResponse.rate)
                case .to:
                    self.fromCurrencyText = String(convertResponse.fromAmount * convertResponse.rate)
                }
                self.updateRateText(fromCurrency: convertResponse.from, toCurrency: convertResponse.to, rate: convertResponse.rate)
            }
        }, onError: { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isErrorAlertShown = true
                self.errorMessage = "Error in conversion"
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Buttons
    
    func fromButtonTapped() {
        isPickerShown = true
        currencyPickerType = .from
        hideKeyboard()
    }
    
    func toButtonTapped() {
        isPickerShown = true
        currencyPickerType = .to
        hideKeyboard()
    }
    
    func switchButtonTapped() {
        isPickerShown = false
        hideKeyboard()
        // Neetly swapping from and to currencies
        (fromCurrency, toCurrency) = (toCurrency, fromCurrency)
        guard firstConversionDone == true else { return }
        convert(fromCurrency: fromCurrency, toCurrency: toCurrency, amountText: fromCurrencyText)
    }
    
    func convertButtonTapped() {
        isPickerShown = false
        convert(fromCurrency: fromCurrency, toCurrency: toCurrency, amountText: fromCurrencyText)
    }
    
    func fromCurrencyTextChanged() {
        guard firstConversionDone == true else { return }
        guard focusedTextFieldType == .from else { return }
        convert(fromCurrency: fromCurrency, toCurrency: toCurrency, amountText: fromCurrencyText)
    }
    
    func toCurrencyTextChanged() {
        guard firstConversionDone == true else { return }
        guard focusedTextFieldType == .to else { return }
        convert(fromCurrency: toCurrency, toCurrency: fromCurrency, amountText: toCurrencyText)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    private func updateRateText(fromCurrency: String, toCurrency: String, rate: Float) {
        rateText = "1 \(fromCurrency) = \(rate) \(toCurrency)"
    }
    
    private func currencySelectionChanged() {
        guard firstConversionDone == true else { return }
        convert(fromCurrency: fromCurrency, toCurrency: toCurrency, amountText: fromCurrencyText)
    }
}
