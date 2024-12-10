# PactSwiftServer

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE.md)

A wrapper around [`libpact_ffi.a`](https://github.com/pact-foundation/pact-reference/tree/master/rust/pact_ffi) binary and exposed as XCFramework to be primarily used by [`PactSwift`](https://github.com/surpher/PactSwift). 

This XCFramework is a [build result](https://github.com/surpher/PactSwiftMockServer/blob/5bfc407a4435969e3658cfb961e8e2ef7db993a5/Support/build_xcframework) of [`PactSwiftMockServer`](https://github.com/surpher/PactSwiftMockServer) and shared here without the git history that includes all overblown versions of `libpact_ffi.a` that blow up the size of the repository.

But nothing is stopping you from creating your own interface using this package.
