# Ankura Homebrew Tap

Homebrew tap for distributing [Ankura](https://github.com/lrangell/ankura), a type-safe Karabiner-Elements configuration tool using Apple's Pkl language.

## Installation

### Direct Install (No Tapping Required)

```bash
brew install lrangell/ankura
```

**That's it!** Homebrew automatically handles the tap behind the scenes.

## Usage

After installation, you can use `ankura` from anywhere:

```bash
# Initialize configuration
ankura init

# Start the daemon
ankura start

# Check status
ankura status

# View logs
ankura logs
```

## Requirements

- macOS 10.15+ (Catalina or later)
- [pkl](https://pkl-lang.org) CLI (automatically installed as dependency)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) (automatically installed as dependency)

## Architecture Support

This tap provides pre-compiled binaries for:
- Intel Macs (`x86_64-apple-darwin`)
- Apple Silicon Macs (`aarch64-apple-darwin`)

## Development

This repository contains:
- `Formula/ankura.rb` - Homebrew formula
- `.github/workflows/` - CI/CD automation
- `scripts/` - Build and release scripts

### Release Process

Releases are automatically triggered by git tags:

```bash
# Create and push a new tag
git tag v0.2.1
git push origin v0.2.1
```

The GitHub Actions workflow will:
1. Cross-compile binaries for both architectures
2. Create a GitHub release with binaries
3. Update the Homebrew formula with new checksums
4. Commit the updated formula

### Manual Build

To build locally:

```bash
# Build for current architecture
./scripts/build-release.sh v0.2.1

# Build for all architectures
./scripts/build-release.sh v0.2.1 all
```

## License

MIT - see [LICENSE](LICENSE) file.

## Links

- [Ankura Repository](https://github.com/lrangell/ankura)
- [Pkl Language](https://pkl-lang.org)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)