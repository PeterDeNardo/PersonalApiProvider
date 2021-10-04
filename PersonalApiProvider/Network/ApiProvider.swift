//
//  ApiProvider.swift
//  MagaluGist
//
//  Created by Peter De Nardo on 29/09/21.
//

import Foundation
import UIKit

public typealias CompletionData = (statusCode: Int, data: Data)
public typealias CompletionCallBack = (@escaping () throws -> CompletionData) -> Void

protocol ApiProviderProtocol {
    func loadData(url: URL, success: @escaping CompletionCallBack, failure: @escaping CompletionCallBack)
    func request(params: [String: Any], url: UrlBody, success: @escaping CompletionCallBack, failure: @escaping CompletionCallBack)
}

public class ApiProvider: ApiProviderProtocol {
    
    ///Singleton instance
    public static let shared = ApiProvider()
    
    public init() { }
    
    public func request(params: [String: Any], url: UrlBody, success: @escaping CompletionCallBack, failure: @escaping CompletionCallBack) {
        let session = URLSession(configuration: .default)
        let components = generateUrlComponents(urlBody: url, params: params)
        guard let url = components.url else { fatalError("link pixado :/")}
        var request = URLRequest(url: url)
        setHeaderParams(request: &request, params: params)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    success{ try self.handleResponse(data, valueReturn: response) }
                } else {
                    failure{ try self.handleResponse(data, valueReturn: response) }
                }
            }
        }.resume()
    
    }
    
    public func loadData(url: URL, success: @escaping CompletionCallBack, failure: @escaping CompletionCallBack) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    success{ try self.handleResponse(data, valueReturn: response) }
                } else {
                    failure{ try self.handleResponse(data, valueReturn: response) }
                }
            }
        }.resume()
    }
    
    private func generateUrlComponents(urlBody: UrlBody, params: [String: Any]) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = urlBody.scheme.rawValue
        urlComponents.host = urlBody.host.rawValue
        urlComponents.path = urlBody.path.rawValue
        let queryParams: [URLQueryItem] = getQueryParams(params: params)
        urlComponents.queryItems = queryParams
        return urlComponents
    }
    
    private func getQueryParams(params: [String: Any]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        params.forEach{ (key, value) in
            if key == "query"{
                if let queryValues = value as? [String: Any] {
                    for value in queryValues {
                        let itemKey = value.key, itemValue = value.value as? Int
                        let item = URLQueryItem(name: itemKey, value: itemValue?.description)
                        queryItems.append(item)
                    }
                }
            }
        }
        return queryItems
    }
    
    private func setHeaderParams( request: inout URLRequest, params: [String: Any]) {
        params.forEach{ (key, value) in
            if key == "header"{
                if let queryValues = value as? [String: Any] {
                    for value in queryValues {
                        let itemKey = value.key, itemValue = value.value as? String ?? ""
                        request.setValue(itemValue, forHTTPHeaderField: itemKey)
                    }
                }
            }
        }
    }
}

//Mark: Case Handles
extension ApiProvider {
    private func handleResponse(_ valueData: Data?, valueReturn: URLResponse?) throws -> CompletionData! {
        if let response = valueReturn as? HTTPURLResponse {
            let status = response.statusCode
            switch status {
            case 200...299:
                if let data = valueData {
                    return (response.statusCode, data)
                } else {
                    throw ApiError.invalidResponse(response.statusCode)
                }
            default:
                throw ApiError.invalidResponse(response.statusCode)
            }
        } else {
            throw ApiError.emptyResponse
        }
        
    }
}
