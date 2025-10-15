class Ankura < Formula
  desc "Type-safe Karabiner-Elements configuration using Apple's Pkl language"
  homepage "https://github.com/lrangell/ankura"
  version "0.3.6"
  license "MIT"

  url "https://github.com/lrangell/ankura/releases/download/v#{version}/ankura-v#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "102e497000f5fd395b764dff8e2a34656f57d6939d2c670704ecd5c223e488df"

  depends_on :macos
  depends_on arch: :arm64
  depends_on "pkl"

  def install
    bin.install "ankura-apple-silicon" => "ankura"

    (var/"log/ankura").mkpath
  end

  def post_install
    (etc/"ankura").mkpath
    (var/"lib/ankura").mkpath
    (share/"ankura").mkpath

    system "#{bin}/ankura", "init"

    system "brew", "services", "start", "lrangell/ankura/ankura"
  end

  service do
    run [opt_bin/"ankura", "start", "--daemon-mode"]
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
      Ankura has been installed, initialized, and the service has been started!

      To get started:
        1. Install Karabiner-Elements (if not already installed):
           brew install --cask karabiner-elements

        2. Edit your configuration file:
           ~/.config/ankura.pkl

        3. View logs:
           ankura logs

      The daemon is already running and watching for changes.
      To stop it: brew services stop ankura
      To restart it: brew services restart ankura

      For more information, visit: #{homepage}
    EOS
  end
end
