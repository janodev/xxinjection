// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "kit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(name: "Kit", type: .dynamic, targets: ["Kit"]),
        .library(name: "KitStatic", type: .static, targets: ["Kit"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Kit",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "KitTests",
            dependencies: ["Kit"],
            path: "sources/tests"
        )
    ]
)
