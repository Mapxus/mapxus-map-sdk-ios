// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.4.0"

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
      checksum: "96243b3c81136047d7a0582d343ac9e54b886581af8226b552d337ba84d8e83e")
  ]
)
