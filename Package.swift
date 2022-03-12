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
