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
                
                // TODO: check if this is correct
                switch self.focusedTextFieldType {
                case .from,
                     .none:
                    //self.rate = convertResponse.rate
                    self.updateRateText(convertResponse.rate)
                    self.toCurrencyText = String(convertResponse.fromAmount * convertResponse.rate)
                case .to:
                    // rate is this oposite
                    //self.updateRateText(convertResponse.fromAmount / convertResponse.toAmount)
                    self.fromCurrencyText = String(convertResponse.fromAmount * convertResponse.rate)
                }
            }
        }, onError: { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // TODO: add alert
                print(error)
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
    
    private func updateRateText(_ rate: Float) {
        rateText = "1 \(fromCurrency.rawValue) = \(rate) \(toCurrency.rawValue)"
    }
    
    private func currencySelectionChanged() {
        guard firstConversionDone == true else { return }
        convert(fromCurrency: fromCurrency, toCurrency: toCurrency, amountText: fromCurrencyText)
    }
}
