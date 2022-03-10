// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "mytumblr",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(name: "MyTumblr", type: .dynamic, targets: ["MyTumblr"]),
        .library(name: "MyTumblrStatic", type: .static, targets: ["MyTumblr"])
    ],
    dependencies: [
        .package(name: "apiclient", url: "git@github.com:janodev/apiclient.git", from: "1.0.0"),
        .package(name: "autolayout", url: "git@github.com:janodev/autolayout.git", from: "1.0.0"),
        .package(name: "codablehelpers", url: "git@github.com:janodev/codablehelpers.git", from: "1.0.0"),
        .package(name: "coordinator", url: "git@github.com:janodev/coordinator.git", from: "1.0.0"),
        .package(name: "coredatastack", url: "git@github.com:janodev/coredatastack.git", from: "1.0.0"),
        .package(name: "injection", url: "git@github.com:janodev/injection.git", from: "1.0.0"),
        .package(name: "keychain", url: "git@github.com:janodev/keychain.git", from: "1.0.0"),
        .package(name: "kit", path: "../kit"),
        .package(name: "OAuth2", path: "../../.."),
        .package(name: "tumblrnpf", url: "git@github.com:janodev/tumblrnpf.git", from: "1.0.0"),
        .package(name: "TumblrNPFPersistence", url: "git@github.com:janodev/tumblrnpfpersistence.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyTumblr",
            dependencies: [
                .product(name: "APIClient", package: "apiclient"),
                .product(name: "AutoLayout", package: "autolayout"),
                .product(name: "CodableHelpers", package: "codablehelpers"),
                .product(name: "Coordinator", package: "coordinator"),
                .product(name: "CoreDataStack", package: "coredatastack"),
                .product(name: "Injection", package: "injection"),
                .product(name: "Keychain", package: "keychain"),
                .product(name: "Kit", package: "kit"),
                .product(name: "OAuth2", package: "oauth2"),
                .product(name: "TumblrNPF", package: "tumblrnpf"),
                .product(name: "TumblrNPFPersistence", package: "TumblrNPFPersistence")
            ],
            path: "sources/main",
            exclude: [
                "tumblr-user.txt"
            ],
            resources: [
                .copy("resources/fonts/Gibson-bold.ttf"),
                .copy("resources/fonts/Gibson-bolditalic.ttf"),
                .copy("resources/fonts/Gibson-regular.ttf"),
                .copy("resources/fonts/Gibson-regularitalic.ttf"),
                .copy("resources/fonts/RugeBoogie-Regular.ttf")
            ]
        ),
        .testTarget(
            name: "MyTumblrTests",
            dependencies: ["MyTumblr"],
            path: "sources/tests"
        )
    ]
)
