class Lazybox < Formula
  desc "A reactive PR inbox and agent workspace manager for the terminal."
  homepage "https://lazybox.ai"
  version "0.1.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.17/lazybox-tui-boot-aarch64-apple-darwin.tar.xz"
      sha256 "2b6ecb153f7ea64f36eb59dc144aad4487fcd8b6b7de76d94be882cdb7f7ba4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.17/lazybox-tui-boot-x86_64-apple-darwin.tar.xz"
      sha256 "25bf202a1028bfefdc6c0f563afd8069f832d997b66257eb9b20221976cabb5b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.17/lazybox-tui-boot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "160f2f20d224d1e9107aa1e940e699eb98015eeb47528c83523c647f0ce6a474"
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
