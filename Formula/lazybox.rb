class Lazybox < Formula
  desc "A reactive PR inbox and agent workspace manager for the terminal."
  homepage "https://lazybox.ai"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.9/lazybox-tui-boot-aarch64-apple-darwin.tar.xz"
      sha256 "bfa7f7a9fcc180a32511f742c47a1581e987aa0d29eed397f61f893bbf234666"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.9/lazybox-tui-boot-x86_64-apple-darwin.tar.xz"
      sha256 "a381d31d517ea0eb169983200b44050c01d74a30d50f62fd42a7ccae92d68f9f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.9/lazybox-tui-boot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0c92361b07c74b693595f478fecf819b50f42765e1a9dcb3c9b4acb5fd7f134a"
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
