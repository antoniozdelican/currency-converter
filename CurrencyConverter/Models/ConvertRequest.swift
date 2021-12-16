//
//  ConvertRequest.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

struct ConvertRequest: Codable {
    
    let from: String
    let to: String
    let amount: Float
}
