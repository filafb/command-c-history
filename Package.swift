// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CmdCHistory",
    platforms: [.macOS(.v13)],
    targets: [
        .target(
            name: "CmdCHistoryCore",
            path: "Sources/CmdCHistoryCore"
        ),
        .executableTarget(
            name: "CmdCHistory",
            dependencies: ["CmdCHistoryCore"],
            path: "Sources/CmdCHistory"
        ),
        .executableTarget(
            name: "TestRunner",
            dependencies: ["CmdCHistoryCore"],
            path: "Sources/TestRunner"
        ),
    ]
)
