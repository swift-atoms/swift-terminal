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
            name: "Terminal Primitive",
            targets: ["Terminal Primitive"]
        ),
        .library(
            name: "Terminal Error",
            targets: ["Terminal Error"]
        ),
        .library(
            name: "Terminal",
            targets: ["Terminal"]
        ),
        .library(
            name: "Terminal Test Support",
            targets: ["Terminal Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-error.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Terminal Primitive",
            dependencies: []
        ),

        .target(
            name: "Terminal Error",
            dependencies: [
                "Terminal Primitive",
                .product(name: "Error", package: "swift-error"),
            ]
        ),

        .target(
            name: "Terminal",
            dependencies: [
                "Terminal Primitive",
                "Terminal Error",
            ]
        ),
        .testTarget(
            name: "Terminal Tests",
            dependencies: [
                "Terminal Primitive",
                "Terminal",
            ]
        ),

        .target(
            name: "Terminal Test Support",
            dependencies: [
                "Terminal"
            ],
            path: "Tests/Support"
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
