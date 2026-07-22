#!/bin/bash
#
#  download-omnisharp.sh
#  Downloads OmniSharp binaries for different platforms and bundles them inside the package.
#

VERSION="v1.39.13"
BASE_URL="https://github.com/OmniSharp/omnisharp-roslyn/releases/download/$VERSION"
TARGET_DIR="bin/omnisharp"

mkdir -p "$TARGET_DIR"

download_and_extract() {
    local platform=$1
    local zip_name=$2
    local dir="$TARGET_DIR/$platform"

    echo "Downloading OmniSharp for $platform ($VERSION)..."
    mkdir -p "$dir"
    
    # Download zip to a temporary file
    local tmp_zip=$(mktemp)
    curl -L "$BASE_URL/$zip_name" -o "$tmp_zip"

    echo "Extracting to $dir..."
    unzip -q -o "$tmp_zip" -d "$dir"
    rm "$tmp_zip"

    # Make executable if not on Windows
    if [[ "$platform" != "win-x64" ]]; then
        chmod +x "$dir/OmniSharp"
    fi
}

# Download for macOS (Apple Silicon and Intel)
download_and_extract "osx-arm64" "omnisharp-osx-arm64-net6.0.zip"
download_and_extract "osx-x64" "omnisharp-osx-x64-net6.0.zip"

# Download for Windows and Linux
download_and_extract "win-x64" "omnisharp-win-x64-net6.0.zip"
download_and_extract "linux-x64" "omnisharp-linux-x64-net6.0.zip"

echo "OmniSharp binaries downloaded and extracted successfully."
