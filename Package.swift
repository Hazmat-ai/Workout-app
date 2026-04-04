// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FitForge",
    platforms: [
        .macOS(.v14), .iOS(.v17)
    ],
    products: [
        .executable(name: "FitForge", targets: ["FitForge"])
    ],
    targets: [
        .executableTarget(
            name: "FitForge",
            path: ".",
            exclude: [
                "README.md",
                "AGENT_CONTEXT.md",
                "project.yml"
            ],
            sources: [
                "App",
                "Core",
                "Features",
                "Components",
                "Resources"
            ]
        )
    ]
)
