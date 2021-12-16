//
//  NetworkError.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

enum NetworkError: LocalizedError {
    case generic
    case badRequest(String?)
}

extension NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .generic:
            return "Generic error"
        case .badRequest(let description):
            return description ?? "Bad request error"
        }
    }
}
