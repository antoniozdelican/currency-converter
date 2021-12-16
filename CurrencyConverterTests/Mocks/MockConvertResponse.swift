//
//  MockConvertResponse.swift
//  CurrencyConverterTests
//
//  Created by Antonio Zdelican on 16.12.21.
//

import XCTest
@testable import CurrencyConverter

var mockConvertResponse = ConvertResponse(from: Currency.euro.rawValue, to: Currency.britishPound.rawValue, rate: 0.85, fromAmount: 1.0, toAmount: 0.85)
var mockConvertResponseData = try! JSONSerialization.data(withJSONObject: mockConvertResponse.jsonObject!, options: .fragmentsAllowed)
