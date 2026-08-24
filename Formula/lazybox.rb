class Lazybox < Formula
  desc "A reactive PR inbox and agent workspace manager for the terminal."
  homepage "https://lazybox.ai"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.13/lazybox-tui-boot-aarch64-apple-darwin.tar.xz"
      sha256 "a2bda648a4d0a36fa78e062ab352d47a80fa772f710b91b86b3f7ea335b1c696"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.13/lazybox-tui-boot-x86_64-apple-darwin.tar.xz"
      sha256 "5d7d48b9071af111e077246fcfaca18f89a5bccf4b5d77c88d56e208e8247edf"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.13/lazybox-tui-boot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "02c6289904a00f87081c1843e4549b957c43e26591a8c6e9a95bbc1d1c61b2fb"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lazybox", "lb"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lazybox", "lb"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lazybox", "lb"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
