// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Hyperhooks",
  platforms: [
    .macOS(.v10_16), .iOS(.v14),
  ],
  products: [
    .library(
      name: "Hyperhooks",
      targets: ["Hyperhooks"]),
  ],
  dependencies: [
    .package(name: "HyperhooksCore", url: "https://github.com/hyperhooks/hyperhooks-core", .branch("develop"))
  ],
  targets: [
    .target(
      name: "Hyperhooks",
      dependencies: [
        
        "HyperhooksCore", // Comment-out to resolve Previews issues with Xcode 12 Beta 3
      ],
      resources: [
        .copy("js/default-main.js"),
        .copy("js/hyperhooks-core.cached.js"),
        .copy("js/hyperhooks-swift.js"),
        .copy("js/base/Empty.js"),
        .copy("js/base/Group.js"),
        .copy("js/html/Button.js"),
        .copy("js/html/Div.js"),
        .copy("js/html/Span.js"),
        .copy("js/html/Input.js"),
        .copy("js/reactnative/View.js"),
        .copy("js/swiftui/HStack.js"),
        .copy("js/swiftui/Spacer.js"),
        .copy("js/swiftui/Text.js"),
        .copy("js/swiftui/VStack.js"),
        .copy("js/swiftui/ZStack.js"),
      ]
    ),
  ]
)
