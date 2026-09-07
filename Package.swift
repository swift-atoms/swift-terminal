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
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-error.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Terminal",
            dependencies: [
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

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
