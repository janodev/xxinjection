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
        .package(name: "apiclient", url: "git@github.com:janodev/apiclient.git", branch: "main"),
        .package(name: "autolayout", url: "git@github.com:janodev/autolayout.git", branch: "main"),
        .package(name: "codablehelpers", url: "git@github.com:janodev/codablehelpers.git", branch: "main"),
        .package(name: "coordinator", url: "git@github.com:janodev/coordinator.git", branch: "main"),
        .package(name: "coredatastack", url: "git@github.com:janodev/coredatastack.git", branch: "main"),
        .package(name: "injection", url: "git@github.com:janodev/injection.git", branch: "main"),
        .package(name: "keychain", url: "git@github.com:janodev/keychain.git", branch: "main"),
        .package(name: "kit", url: "git@github.com:janodev/kit.git", branch: "main"),
        .package(name: "OAuth2", path: "../../.."),
        .package(name: "tumblrnpf", url: "git@github.com:janodev/tumblrnpf.git", branch: "main"),
        .package(name: "TumblrNPFPersistence", url: "git@github.com:janodev/tumblrnpfpersistence.git", branch: "main")
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Injection",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "MyTumblrTests",
            dependencies: ["MyTumblr"],
            path: "sources/tests",
            resources: [
                .copy("resources/401.json"),
                .copy("resources/APIError.json"),
                .copy("resources/swift-index.json"),
                .copy("resources/tumblr1.json"),
                .copy("resources/tumblr2.json"),
                .copy("resources/tumblr3.json")
            ]
        )
    ]
)
