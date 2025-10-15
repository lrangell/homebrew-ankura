# Ankura Homebrew Tap

Homebrew tap for distributing [Ankura](https://github.com/lrangell/ankura), a type-safe Karabiner-Elements configuration tool using Apple's Pkl language.

## Installation

### Direct Install (No Tapping Required)

```bash
brew install lrangell/ankura/ankura
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
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) (install separately: `brew install --cask karabiner-elements`)

## Architecture Support

This tap provides pre-compiled binaries for:
- Apple Silicon Macs only (`aarch64-apple-darwin`)

## Development

This repository contains:
- `Formula/ankura.rb` - Homebrew formula
- `.github/workflows/` - CI/CD automation
- `scripts/` - Build and release scripts

### Release Process

**All workflows moved to main ankura repository for cleaner separation of concerns.**

**Step 1: Copy Workflow Files to Main Repo**
```bash
# Copy these files to lrangell/ankura/.github/workflows/
cp main-repo-ci.yml → ci.yml        # Cargo/Pkl tests on every commit
cp ankura-repo-release.yml → release.yml   # Build binaries on git tags
```

**Step 2: Create Release (Main Ankura Repo)**
```bash
# In the main ankura repository  
git tag v0.2.1
git push origin v0.2.1
```

This triggers the release workflow which:
1. ✅ Runs cargo fmt, clippy, and check
2. ✅ Builds release binary for Apple Silicon
3. ✅ Creates GitHub release with binary and checksum
4. ✅ Automatically updates the Homebrew formula

**Repository Responsibilities:**
- **Main Repo**: Code testing, building, releasing binaries
- **Homebrew Repo**: Formula validation, dependency management

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