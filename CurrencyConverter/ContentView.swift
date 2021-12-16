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
        Text("Hello, world!")
            .padding()
    }
}
