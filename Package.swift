// swift-tools-version:5.9

import PackageDescription

let package = Package(

	name: "PactSwiftMockServer",

	platforms: [
		.macOS(.v10_12),
		.iOS(.v12),
		.tvOS(.v12)
	],

	products: [
		.library(
			name: "PactSwiftMockServer",
			targets: ["PactSwiftMockServer"]
		),
	],

	dependencies: [
		.package(name: "PactMockServer", url: "https://github.com/surpher/PactMockServer.git", .exact("0.1.2")),
	],

	// MARK: - Targets

	targets: [
		// The XCFramwork binary for Apple's platforms
		.binaryTarget(
			name: "PactSwiftMockServer",
			path: "Framework/PactSwiftMockServer.xcframework"
		),
	],

	swiftLanguageVersions: [.v5]
)