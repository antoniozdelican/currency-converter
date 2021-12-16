//
//  NetworkRequest.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
}

typealias RequestHeaders = [String: String]
typealias RequestParameters = [String : Any?]

protocol NetworkRequestProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: RequestHeaders? { get }
    var parameters: RequestParameters? { get }
}

extension NetworkRequestProtocol {
    
    func urlRequest() -> URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else {
            return nil
        }
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else {
            return nil
        }
        // Convert parameters to query items
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString = String(describing: value ?? "")
            return URLQueryItem(name: key, value: valueString)
        }
    }
}
