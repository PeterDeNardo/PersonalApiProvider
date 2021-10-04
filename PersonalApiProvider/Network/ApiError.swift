//
//  ApiModel.swift
//  MagaluGist
//
//  Created by Peter De Nardo on 01/10/21.
//

import Foundation

public enum ApiError: Error {
    case unknowError(Int)
    case emptyResponse
    case invalidResponse(Int)
}
