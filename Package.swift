// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "DIKit",
  platforms: [
      .macOS(.v12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
  ],
  products: [
    .executable(name: "dikitgen", targets: ["dikitgen"]),
    .library(name: "DIKit", targets: ["DIKit"]),
    .library(name: "DIGenKit", targets: ["DIGenKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/Rerurate514/SourceKitten.git",.exact("0.36.1"))
  ],
  targets: [
    .target(name: "DIKit"),
    .target(name: "DIGenKit", dependencies: ["DIKit",.product(name: "SourceKittenFramework", package: "SourceKitten")]),
    .target(name: "dikitgen", dependencies: ["DIGenKit"]),
    .testTarget(name: "DIGenKitTests", dependencies: ["DIGenKit"])
  ],
  swiftLanguageVersions: [.v5]
)

// // swift-tools-version:5.5
// import PackageDescription

// let package = Package(
//     name: "DIKit",
//     platforms: [
//       .macOS(.v12),.iOS(.v9),.tvOS(.v9),.watchOS(.v2)
//     ],
//     products: [
//       .executable(name: "dikitgen", targets: ["dikitgen"]),
//       .library(name: "DIKit", targets: ["DIKit"]),
//       .library(name: "DIGenKit", targets: ["DIGenKit"])
//     ],
//     dependencies: [
//       .package(url: "https://github.com/Rerurate514/SourceKitten.git",.exact("0.36.1"))
//     ],
//     targets: [
//       .target(name: "DIKit"),
//       .target(name: "DIGenKit", dependencies: ["DIKit",.product(name: "SourceKittenFramework", package: "SourceKitten")]),
//       .executableTarget(name: "dikitgen", dependencies: ["DIGenKit"]),
//       .testTarget(name: "DIGenKitTests", dependencies: ["DIGenKit"])
//     ],
//     swiftLanguageVersions: [.v5]
// )
