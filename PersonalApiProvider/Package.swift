//
//  Package.swift
//  PersonalApiProvider
//
//  Created by Peter De Nardo on 04/10/21.
//

import Foundation

let package = Pakage {
platforms: [
  .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
],

products: [
  .library(
    name: "CalendarControl",
    targets: ["CalendarControl"]),
],

targets: [
  .binaryTarget(
    name: "CalendarControl",
    path: "./Sources/CalendarControl.xcframework")
]
}
