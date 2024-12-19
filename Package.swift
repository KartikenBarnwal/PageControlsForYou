// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "PageControlsForYou",
    platforms: [
        .iOS(.v13) // Specify minimum iOS version
    ],
    products: [
        .library(
            name: "PageControlsForYou",
            targets: ["PageControlsForYou"]
        ),
    ],
    targets: [
        .target(
            name: "PageControlsForYou",
            path: "Sources/PageControlsForYou" // Your main library code
        ),
        .testTarget(
            name: "PageControlsForYouTests",
            dependencies: ["PageControlsForYou"],
            path: "Tests/PageControlsForYouTests"
        ),
    ]
)
