// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-terminal",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Terminal",
            targets: ["Terminal"]
        ),
        .library(
            name: "Terminal Error",
            targets: ["Terminal Error"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-error.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Terminal",
            dependencies: []
        ),

        .target(
            name: "Terminal Error",
            dependencies: [
                .target(name: "Terminal"),
                .product(name: "Error", package: "swift-error"),
            ]
        ),
        .testTarget(
            name: "Terminal Tests",
            dependencies: [
                .target(name: "Terminal"),
            ]
        ),
        .testTarget(
            name: "Terminal Error Tests",
            dependencies: [
                .target(name: "Terminal Error"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
