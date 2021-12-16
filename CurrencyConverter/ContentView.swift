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
            VStack(spacing: 20) {
                HStack(alignment: .bottom, spacing: 10) {
                    fromButton
                    switchButton
                        .frame(width: 40)
                    toButton
                }
                Spacer()
            }
            .padding(20)
            .navigationBarTitle(Text("Currency Converter"), displayMode: .inline)
        }
    }
    
    var fromButton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FROM:")
                .font(.caption)
                .foregroundColor(.gray)
            Button {
                // TODO
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
        VStack(alignment: .leading, spacing: 10) {
            Text("TO:")
                .font(.caption)
                .foregroundColor(.gray)
            Button {
                // TODO
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
        VStack(alignment: .leading, spacing: 10) {
            Button {
                // TODO
            } label: {
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                }
            }
            Divider()
                .opacity(0)
        }
    }
}
