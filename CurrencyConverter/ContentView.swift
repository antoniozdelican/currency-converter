//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .onTapGesture {
                        viewModel.isPickerShown = false
                        viewModel.hideKeyboard()
                    }
                VStack(spacing: 30) {
                    HStack(alignment: .bottom, spacing: 10) {
                        fromButton
                        switchButton
                            .frame(width: 40)
                        toButton
                    }
                    HStack(alignment: .bottom, spacing: 60) {
                        fromTextField
                        if viewModel.firstConversionDone {
                            toTextField
                        }
                    }
                    if viewModel.firstConversionDone {
                        infoView
                    } else {
                        convertButton
                    }
                    Spacer()
                    if viewModel.isPickerShown {
                        CurrencyPicker()
                            .environmentObject(viewModel)
                    }
                }
                .padding(20)
            }
            .navigationBarTitle(Text("Currency Converter"), displayMode: .inline)
        }
    }
    
    var fromButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FROM:")
                .font(.caption)
                .foregroundColor(.gray)
            Button {
                viewModel.fromButtonTapped()
            } label: {
                HStack {
                    viewModel.fromCurrency.image
                    Text(viewModel.fromCurrency.rawValue)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Divider()
        }
    }
    
    var toButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TO:")
                .font(.caption)
                .foregroundColor(.gray)
            Button {
                viewModel.toButtonTapped()
            } label: {
                HStack {
                    viewModel.toCurrency.image
                    Text(viewModel.toCurrency.rawValue)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Divider()
        }
    }
    
    var switchButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                viewModel.switchButtonTapped()
            } label: {
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                }
            }
            Divider()
                .opacity(0)
        }
    }
    
    var fromTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AMOUNT:")
                .font(.caption)
                .foregroundColor(.gray)
            HStack(spacing: 5) {
                TextField("", text: $viewModel.fromCurrencyText, onEditingChanged: { editingChanged in
                    if editingChanged {
                        viewModel.focusedTextFieldType = .from
                    }
                })
                    .onReceive(viewModel.$fromCurrencyText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
                        guard !$0.isEmpty else { return }
                        // Fire convert request 1 sec after user ends typing into textField
                        viewModel.fromCurrencyTextChanged()
                    }
                    .keyboardType(.decimalPad)
                Text(viewModel.fromCurrency.rawValue)
                    .foregroundColor(.gray)
            }
            Divider()
        }
    }
    
    var toTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CONVERTED TO:")
                .font(.caption)
                .foregroundColor(.gray)
            HStack(spacing: 5) {
                TextField("", text: $viewModel.toCurrencyText, onEditingChanged: { editingChanged in
                    viewModel.focusedTextFieldType = editingChanged ? .to : .none
                })
                    .onReceive(viewModel.$toCurrencyText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
                        guard !$0.isEmpty else { return }
                        // Fire convert request 1 sec after user ends typing into textField
                        viewModel.toCurrencyTextChanged()
                    }
                    .keyboardType(.decimalPad)
                Text(viewModel.toCurrency.rawValue)
                    .foregroundColor(.gray)
            }
            Divider()
        }
    }
    
    var convertButton: some View {
        Button {
            viewModel.convertButtonTapped()
        } label: {
            Text("Convert")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .background(Color.green)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 10, alignment: .center)
                    .foregroundColor(.yellow)
                Text(viewModel.rateText)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            Text("All figures are live mid-market rates, which are for informational purposes only. To see the rates for money transfer, please select sending money option.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
