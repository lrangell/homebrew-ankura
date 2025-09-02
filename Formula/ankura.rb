class Ankura < Formula
  desc "Type-safe Karabiner-Elements configuration using Apple's Pkl language"
  homepage "https://github.com/lrangell/ankura"
  version "0.2.0"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/lrangell/ankura/releases/download/v#{version}/ankura-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000" # Will be updated by CI
  elsif Hardware::CPU.arm?
    url "https://github.com/lrangell/ankura/releases/download/v#{version}/ankura-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000" # Will be updated by CI
  end

  depends_on "pkl"

  def install
    bin.install "ankura"
    
    # Create log directory
    (var/"log/ankura").mkpath
  end

  def post_install
    # Create config directories
    (etc/"ankura").mkpath
    (var/"lib/ankura").mkpath
  end

  service do
    run [opt_bin/"ankura", "start", "--foreground"]
    log_path var/"log/ankura/ankura.log"
    error_log_path var/"log/ankura/ankura.log"
    keep_alive true
  end

  test do
    system "#{bin}/ankura", "--version"
    system "#{bin}/ankura", "check", "--help"
  end

  def caveats
    <<~EOS
      To get started with Ankura:
        1. Install Karabiner-Elements:
           brew install --cask karabiner-elements

        2. Initialize your configuration:
           ankura init

        3. Edit your configuration file:
           ~/.config/ankura.pkl

        4. Start the daemon to watch for changes:
           ankura start

      For more information, visit: #{homepage}
    EOS
  end
end