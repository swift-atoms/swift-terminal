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
            name: "Terminal Standard Library Integration",
            targets: ["Terminal Standard Library Integration"]
        ),
        .library(
            name: "Terminal Apple Foundation Integration",
            targets: ["Terminal Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Terminal",
            dependencies: []
        ),
        .target(
            name: "Terminal Standard Library Integration",
            dependencies: ["Terminal"]
        ),
        .target(
            name: "Terminal Apple Foundation Integration",
            dependencies: [
                "Terminal",
                "Terminal Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Terminal Tests",
            dependencies: ["Terminal"],
            path: "Tests/Terminal Tests"
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
