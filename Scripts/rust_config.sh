#!/usr/bin/env bash

#  Created by Marko Justinek on 27/8/24.
#  Copyright © 2024 Marko Justinek. All rights reserved.
#  Permission to use, copy, modify, and/or distribute this software for any
#  purpose with or without fee is hereby granted, provided that the above
#  copyright notice and this permission notice appear in all copies.
#
#  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
#  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
#  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

set -eou pipefail

SOURCE_DIR="${BASH_SOURCE[0]%/*}"

# "import"
source "$SOURCE_DIR/utils.sh"

echo "ℹ️  List installed apple triples"
execute_command "rustup target list | grep apple"

# Config

# Supported target architectures
TARGET_ARM64_DARWIN="aarch64-apple-darwin"    # macOS running on Apple Silicon machine
TARGET_X86_64_DARWIN="x86_64-apple-darwin"    # macOS running on Intel machine
TARGET_ARM64_IOS="aarch64-apple-ios"          # physical iOS device
TARGET_ARM64_IOS_SIM="aarch64-apple-ios-sim"  # iOS Simulator running on Apple Silicon machine
TARGET_x86_64_IOS="x86_64-apple-ios"          # iOS Simulator running on Intel machine

TARGETS=(
  "$TARGET_ARM64_DARWIN"
  "$TARGET_ARM64_IOS"
  "$TARGET_ARM64_IOS_SIM"
  "$TARGET_X86_64_DARWIN"
  "$TARGET_x86_64_IOS"
)

# pact-reference/rust/pact_ffi/CMakeLists.txt uses nightly!
TOOLCHAIN_AARCH64="nightly-aarch64-apple-darwin"
TOOLCHAIN_X86_64="nightly-x86_64-apple-darwin"

##############
# Interface

# pact-reference/rust/pact_ffi/CMakeLists.txt uses nightly!
# If using stable, `cbindgen` command fails ¯\_(ツ)_/¯
function rustup_install_nightly {
  echo "⚠️  Installing nightly toolchain"
  execute_command "rustup install nightly"
  execute_command "rustup toolchain install nightly"

  if [ "$(is_arm64)" == "false" ]; then
    execute_command "rustup component add rustfmt --toolchain nightly"
  fi
}

# Set default toolchain for the machine building libpact_ffi.a binaries
function rustup_set_default_toolchain {
  echo "ℹ️  Installing necessary rust toolchain for host machine's architecture"
  DEFAULT_TOOLCHAIN=
  if [ "$(is_arm64)" == "true" ]; then
    DEFAULT_TOOLCHAIN=$TOOLCHAIN_AARCH64
  else
    DEFAULT_TOOLCHAIN=$TOOLCHAIN_X86_64
  fi
  execute_command "rustup default $DEFAULT_TOOLCHAIN"
}

# Add target architectures PactSwift supports
function rustup_add_targets {
  echo "ℹ️  Add necessary targets"
  for TARGET in "${TARGETS[@]}"; do
    echo "ℹ️  Adding target '$TARGET'"
    execute_command "rustup target add $TARGET"
  done
}
