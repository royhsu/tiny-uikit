// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "TinyUIKit",
  platforms: [.iOS(.v9)],
  products: [.library(name: "TinyUIKit", targets: ["TinyUIKit"])],
  targets: [
    .target(name: "TinyUIKit"),
    .testTarget(name: "TinyUIKitTests", dependencies: ["TinyUIKit"]),
  ]
)
