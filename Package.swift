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
        .library(name: "Terminal", targets: ["Terminal"]),

        .library(name: "Terminal Foundation Integration", targets: ["Terminal Foundation Integration"]),
        .library(name: "Terminal Test Support", targets: ["Terminal Test Support"]),
    ],
    traits: [
        .trait(name: "Input", description: "Absorbed swift-terminal-input APIs"),
        .trait(name: "Error", description: "Absorbed swift-terminal-error APIs"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ascii.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-error.git", branch: "main"),
    ],
    targets: [
        .testTarget(
            name: "Absorbed swift-terminal-input Tests",
            dependencies: [
                .target(name: "Terminal"),
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
            ],
            path: "Tests/Absorbed swift-terminal-input"
        ),
        .testTarget(
            name: "Absorbed swift-terminal-error Tests",
            dependencies: [
                .target(name: "Terminal"),
                .product(name: "Error", package: "swift-error"),
            ],
            path: "Tests/Absorbed swift-terminal-error"
        ),
        .target(
            name: "Terminal",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Error", package: "swift-error"),
            ],
            path: "Sources/Terminal"
        ),

        .target(
            name: "Terminal Foundation Integration",
            dependencies: [
                .target(name: "Terminal"),
            ],
            path: "Sources/Terminal Foundation Integration"
        ),
        .target(
            name: "Terminal Test Support",
            dependencies: [
                .target(name: "Terminal"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Terminal Tests",
            dependencies: [
                .target(name: "Terminal"),
                .target(name: "Terminal Test Support"),
                .target(name: "Terminal Foundation Integration"),
            ],
            path: "Tests/Terminal Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
