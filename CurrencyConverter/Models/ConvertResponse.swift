//
//  ConvertResponse.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

struct ConvertResponse: Codable {
    
    let from: String
    let to: String
    let rate: Float
    let amount: Float
    let fromAmount: Float
    let toAmount: Float
}
