// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "myteamwork",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(name: "MyTeamwork", type: .dynamic, targets: ["MyTeamwork"]),
        .library(name: "MyTeamworkStatic", type: .static, targets: ["MyTeamwork"])
    ],
    dependencies: [
        .package(name: "apiclient", url: "git@github.com:janodev/apiclient.git", from: "1.0.0"),
        .package(name: "autolayout", url: "git@github.com:janodev/autolayout.git", from: "1.0.0"),
        .package(name: "codablehelpers", url: "git@github.com:janodev/codablehelpers.git", from: "1.0.0"),
        .package(name: "coordinator", url: "git@github.com:janodev/coordinator.git", from: "1.0.0"),
        .package(name: "injection", url: "git@github.com:janodev/injection.git", from: "1.0.0"),
        .package(name: "keychain", url: "git@github.com:janodev/keychain.git", from: "1.0.0"),
        .package(name: "kit", path: "../kit"),
        .package(name: "OAuth2", path: "../../..")
    ],
    targets: [
        .target(
            name: "MyTeamwork",
            dependencies: [
                .product(name: "APIClient", package: "apiclient"),
                .product(name: "AutoLayout", package: "autolayout"),
                .product(name: "CodableHelpers", package: "codablehelpers"),
                .product(name: "Coordinator", package: "coordinator"),
                .product(name: "Injection", package: "injection"),
                .product(name: "Keychain", package: "keychain"),
                .product(name: "Kit", package: "kit"),
                .product(name: "OAuth2", package: "OAuth2")
            ],
            path: "sources/main",
            exclude: []
        ),
        .testTarget(
            name: "MyTeamworkTests",
            dependencies: ["MyTeamwork"],
            path: "sources/tests"
        )
    ]
)
