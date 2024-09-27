// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.11.0"

let package = Package(
  name: "MapxusMapSDK",
  platforms: [
    .iOS(.v9),
  ],
  products: [
    .library(
      name: "MapxusMapSDK",
      targets: ["MapxusMapSDK"]),
  ],
  targets: [
    .binaryTarget(
      name: "MapxusMapSDK",
      url: "https://nexus3.mapxus.com/repository/ios-sdk/\(version)/mapxus-map-sdk-ios.zip",
      checksum: "f8c2bcc212380fe51704764bbb0b393de85fc31eadbe26bdaa2dd3415da62e2a"
    )
  ]
)
