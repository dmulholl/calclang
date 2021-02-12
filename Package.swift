// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CalcLang",
    products: [
        .library(
            name: "CalcLang",
            targets: ["CalcLang"]),
    ],
    targets: [
        .target(
            name: "CalcLang",
            dependencies: []),
        .testTarget(
            name: "CalcLangTests",
            dependencies: ["CalcLang"]),
    ]
)
