//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation
import SwiftUI

enum Currency: String, CaseIterable, Identifiable {
    
    case euro = "EUR"
    case britishPound = "GBP"
    case russianRuble = "RUB"
    case polishZloty = "PLN"
    case romanianLeu = "RON"
    case ukranianHryvnia = "UAH"
    case turkishLira = "TRY"
    
    var id: String { self.rawValue }
    
    var image: Image {
        var uiImage: UIImage?
        switch self {
        case .euro:
            uiImage = UIImage(named: "EU")?.withRenderingMode(.alwaysOriginal)
        case .britishPound:
            uiImage = UIImage(named: "GB")?.withRenderingMode(.alwaysOriginal)
        case .russianRuble:
            uiImage = UIImage(named: "RU")?.withRenderingMode(.alwaysOriginal)
        case .polishZloty:
            uiImage = UIImage(named: "PL")?.withRenderingMode(.alwaysOriginal)
        case .romanianLeu:
            uiImage = UIImage(named: "RO")?.withRenderingMode(.alwaysOriginal)
        case .ukranianHryvnia:
            uiImage = UIImage(named: "UA")?.withRenderingMode(.alwaysOriginal)
        case .turkishLira:
            uiImage = UIImage(named: "TR")?.withRenderingMode(.alwaysOriginal)
        }
        guard let uiImage = uiImage else {
            return Image(systemName: "flag")
        }
        return Image(uiImage: uiImage)
    }
}
