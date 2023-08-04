// swift-tools-version:5.3

import PackageDescription

let package = Package(

	name: "PactSwiftMockServer",

	platforms: [
		.macOS(.v10_13),
		.iOS(.v12),
		.tvOS(.v12)
	],

	products: [
		.library(
			name: "PactSwiftMockServer",
			targets: ["PactSwiftMockServer"]
		),
	],

	dependencies: [],

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
