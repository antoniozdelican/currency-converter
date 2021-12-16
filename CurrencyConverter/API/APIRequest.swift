//
//  APIRequest.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

enum APIRequest: NetworkRequestProtocol {
    case convert(_ request: ConvertRequest)
}

extension APIRequest {
    
    var baseUrl: String {
        return "https://my.transfergo.com/api/"
    }
    
    var path: String {
        return "fx-rates"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var headers: RequestHeaders? {
        return ["Content-Type" : "application/json"]
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .convert(let request):
            return request.jsonObject
        }
    }
}
