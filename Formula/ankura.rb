class Ankura < Formula
  desc "Type-safe Karabiner-Elements configuration using Apple's Pkl language"
  homepage "https://github.com/lrangell/ankura"
  version "0.3.0"
  license "MIT"

  url "https://github.com/lrangell/ankura/releases/download/v#{version}/ankura-v#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "891cfeeb25c3d47fcf0098a23e4a4163c829fe45b8d27ee6377be2af60d223f1"

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
      Ankura has been installed and initialized!

      To get started:
        1. Install Karabiner-Elements:
           brew install --cask karabiner-elements

        2. Edit your configuration file:
           ~/.config/ankura.pkl

        3. Start the daemon:
           brew services start ankura

        4. View logs:
           ankura logs

      For more information, visit: #{homepage}
    EOS
  end
end
