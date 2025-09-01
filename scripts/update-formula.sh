#!/bin/bash
set -euo pipefail

# Update Homebrew formula with new version and checksums
# Usage: ./scripts/update-formula.sh <version> <x86_checksum> <arm_checksum>

VERSION=${1:-}
X86_CHECKSUM=${2:-}
ARM_CHECKSUM=${3:-}

if [[ -z "$VERSION" || -z "$X86_CHECKSUM" || -z "$ARM_CHECKSUM" ]]; then
    echo "Usage: $0 <version> <x86_checksum> <arm_checksum>"
    echo "Example: $0 v0.2.1 abc123... def456..."
    exit 1
fi

# Remove 'v' prefix if present
VERSION_NO_V=${VERSION#v}

echo "Updating formula for version $VERSION_NO_V"
echo "x86_64 checksum: $X86_CHECKSUM"
echo "aarch64 checksum: $ARM_CHECKSUM"

# Create backup
cp Formula/ankura.rb Formula/ankura.rb.bak

# Update version
sed -i.tmp "s/version \".*\"/version \"$VERSION_NO_V\"/" Formula/ankura.rb

# Update checksums - need to be careful about order
# First occurrence is for Intel, second is for ARM
sed -i.tmp "1,/sha256 \".*\"/ s/sha256 \".*\"/sha256 \"$X86_CHECKSUM\"/" Formula/ankura.rb
sed -i.tmp "1,/sha256 \".*\"/ {/sha256 \"$X86_CHECKSUM\"/!s/sha256 \".*\"/sha256 \"$ARM_CHECKSUM\"/}" Formula/ankura.rb

# Remove temporary files
rm Formula/ankura.rb.tmp

echo "✅ Formula updated successfully!"
echo ""
echo "Changes made:"
echo "- Version: $VERSION_NO_V"
echo "- Intel checksum: $X86_CHECKSUM"
echo "- ARM checksum: $ARM_CHECKSUM"

# Show diff if git is available
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    echo ""
    echo "Git diff:"
    git diff Formula/ankura.rb || true
fi