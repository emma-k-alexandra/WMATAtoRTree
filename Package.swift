// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WMATAtoRTree",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "RTree",
            url: "https://github.com/emma-k-alexandra/RTree.git",
            .upToNextMajor(from: .init(2, 2, 1))
        ),
        .package(
            name: "WMATA",
            url: "https://github.com/emma-k-alexandra/WMATA.swift.git",
            .upToNextMajor(from: .init(13, 2, 0))
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "WMATAtoRTree",
            dependencies: [
                "WMATA",
                "RTree"
            ]
        ),
        .testTarget(
            name: "WMATAtoRTreeTests",
            dependencies: ["WMATAtoRTree"]),
    ]
)
