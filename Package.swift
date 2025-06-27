// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "8.0.1"

let package = Package(
  name: "MapxusMapSDK",
  platforms: [
    .iOS(.v13),
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
      checksum: "a2ce96eea02fd5e07abe5035236ad7b878682e5b84fe2aa315e1c90c87a13b0d"
    )
  ]
)
