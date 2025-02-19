// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "7.3.0"

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
      checksum: "09367c6811ddec46842ac55d82db1a06fa462a9399ef926e9fb801480d1b2d96"
    )
  ]
)
