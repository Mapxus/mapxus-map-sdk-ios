// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "8.6.0"

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
      checksum: "19b9bfe3a2523d86ab53aa6b4ab319df9ba39dac5b30e40b9d98a5af2ccde972"
    )
  ]
)
