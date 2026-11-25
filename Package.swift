// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LoveCat",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "LoveCat",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)