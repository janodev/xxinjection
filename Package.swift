// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "injection",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(name: "Injection", type: .dynamic, targets: ["Injection"]),
        .library(name: "InjectionStatic", type: .static, targets: ["Injection"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Injection",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "InjectionTests",
            dependencies: ["Injection"],
            path: "sources/tests"
        )
    ]
)
