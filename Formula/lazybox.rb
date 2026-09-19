class Lazybox < Formula
  desc "A reactive PR inbox and agent workspace manager for the terminal."
  homepage "https://lazybox.ai"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.16/lazybox-tui-boot-aarch64-apple-darwin.tar.xz"
      sha256 "aad59a94b52fef5a26b67201447d5f3799fc7cdcd5c668909d850e1840d17db3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.16/lazybox-tui-boot-x86_64-apple-darwin.tar.xz"
      sha256 "d3477b9b9e6c9c2e1701078a075ddd042c9bc414cb84364eb957bb25d0b512b9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.16/lazybox-tui-boot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9021d22610659e8d6e237dbfcd64432514d68c1c162bb876284b2ccb219177c1"
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
