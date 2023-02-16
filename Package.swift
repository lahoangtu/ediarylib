// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ediarylib",
  products: [
    .library(
      name: "ediarylib",
      targets: ["ediarylib"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ediarylib",
      dependencies: []),
    .testTarget(
      name: "ediarylibTests",
      dependencies: ["ediarylib"]),
  ]
)
