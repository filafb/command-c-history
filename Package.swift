// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CmdCHistory",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "CmdCHistory",
            path: "Sources/CmdCHistory"
        )
    ]
)
