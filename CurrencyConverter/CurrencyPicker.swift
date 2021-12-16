//
//  CurrencyPicker.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import SwiftUI

enum CurrencyPickerType {
    case from, to
}

struct CurrencyPicker: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    private var selection: Binding<Currency> {
        switch viewModel.currencyPickerType {
        case .from:
            return $viewModel.fromCurrency
        case .to:
            return $viewModel.toCurrency
        }
    }
    
    var body: some View {
        Picker("Currency", selection: selection) {
            ForEach(Currency.allCases, id: \.self) { currency in
                Text(currency.rawValue)
            }
        }
    }
}
