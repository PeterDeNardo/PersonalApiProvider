//
//  File.swift
//  PersonalApiProvider
//
//  Created by Peter De Nardo on 04/10/21.
//

import Foundation

public struct UrlBody {
    public let scheme: String
    public let host: String
    public let path: String
    
    public init(scheme: String, host: String, path: String) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
}
