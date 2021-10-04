//
//  UrlModel.swift
//  MagaluGist
//
//  Created by Peter De Nardo on 01/10/21.
//

import Foundation

public struct UrlBody {
    let scheme: Scheme
    let host: Host
    let path: Path
}

public enum Scheme: String {
    case https = "https"
}

public enum Host: String {
    case api_guthub = "api.github.com"
}

public enum Path: String {
    case gist_public = "/gists/public"
}
