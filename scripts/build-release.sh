#!/bin/bash
set -euo pipefail

# Build script for cross-compiling ankura releases
# Usage: ./scripts/build-release.sh <version> [target]

VERSION=${1:-}
TARGET=${2:-"aarch64-apple-darwin"}

if [[ -z "$VERSION" ]]; then
    echo "Usage: $0 <version> [target]"
    echo "Example: $0 v0.2.1 aarch64-apple-darwin"
    exit 1
fi

# Supported targets
TARGETS=(
    "x86_64-apple-darwin"
    "aarch64-apple-darwin"
)

if [[ "$TARGET" != "all" ]] && [[ ! " ${TARGETS[*]} " =~ " $TARGET " ]]; then
    echo "Unsupported target: $TARGET"
    echo "Supported targets: ${TARGETS[*]} all"
    exit 1
fi

# Install pkl CLI if not present
if ! command -v pkl &> /dev/null; then
    echo "Installing pkl CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            curl -L -o pkl https://github.com/apple/pkl/releases/download/0.29.1/pkl-macos-aarch64
        else
            curl -L -o pkl https://github.com/apple/pkl/releases/download/0.29.1/pkl-macos-amd64
        fi
        chmod +x pkl
        sudo mv pkl /usr/local/bin/
    else
        echo "Unsupported OS for automatic pkl installation"
        exit 1
    fi
fi

build_target() {
    local target=$1
    echo "Building for target: $target"
    
    # Install target if not present
    rustup target add "$target"
    
    # Build release binary
    cargo build --release --target "$target"
    
    # Strip binary to reduce size
    strip "target/$target/release/ankura" || true
    
    # Create release directory
    mkdir -p "releases/$VERSION"
    
    # Create archive
    cd "target/$target/release"
    tar -czf "../../../releases/$VERSION/ankura-$VERSION-$target.tar.gz" ankura
    cd - > /dev/null
    
    # Generate checksum
    cd "releases/$VERSION"
    shasum -a 256 "ankura-$VERSION-$target.tar.gz" > "ankura-$VERSION-$target.sha256"
    cd - > /dev/null
    
    echo "✅ Built: releases/$VERSION/ankura-$VERSION-$target.tar.gz"
    echo "📝 Checksum: $(cat "releases/$VERSION/ankura-$VERSION-$target.sha256" | cut -d' ' -f1)"
}

# Build targets
if [[ "$TARGET" == "all" ]]; then
    for t in "${TARGETS[@]}"; do
        build_target "$t"
    done
else
    build_target "$TARGET"
fi

echo ""
echo "🎉 Build complete! Files in releases/$VERSION/"
ls -la "releases/$VERSION/"