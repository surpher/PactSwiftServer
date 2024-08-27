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

set -euo pipefail

SOURCE_DIR="${BASH_SOURCE[0]%/*}"

# "import"
source "$SOURCE_DIR/config.sh"

# Utilities

function is_arm64 {
  if [ "$(uname -m)" == "arm64" ]; then
    echo true
  else
    echo false
  fi
}

function execute_command {
  if [ $# -eq 0 ]; then
    echo -e "No command provided"
    exit 1
  else
    COMMAND="$1"
    printf "🤖 Executing:\n   '%s'\n" "$COMMAND"
    eval "$COMMAND"
  fi
}

function folder_exists {
  if [ ! -d "$1" ]; then
    echo false
  else
    echo true
  fi
}

function file_exists {
  if [ ! -f "$1" ]; then
    echo false
  else
    echo true
  fi
}

function is_installed {
  if command -v "$1" &> /dev/null; then
    echo true
  else
    echo false
  fi
}

# Xcode version number
# Don't call this directly!
function __check_xcode_version {
  local major_version=${1:-0}
  local minor_version=${2:-0}

  local suggested_major="${MIN_SUGGESTED_XCODE_VERSION%.*}"
  local min_supported_major="${MIN_SUPPORTED_XCODE_VERSION%.*}"
  local min_supported_minor="${MIN_SUPPORTED_XCODE_VERSION##*.}"

  return $(( (major_version >= suggested_major) || (major_version == min_supported_major && minor_version >= min_supported_minor) ))
}

# Checks for Xcode and it's version.
# Exits with non-zero if not found or version is not supported.
function check_xcode() {
  if ! version="$(xcodebuild -version | sed -n '1s/^Xcode \([0-9.]*\)$/\1/p')"; then
    echo 'error: Failed to find Xcode version.' 1>&2
    exit 1
  elif __check_xcode_version ${version//./ }; then # Intentinoally not double quoting to preserve number of parameters
    echo "error: '$version' is not supported! '$MIN_SUGGESTED_XCODE_VERSION' or later is required." 1>&2;
    exit 1
  else
    echo "info: Xcode '$version' installed."
  fi
}
