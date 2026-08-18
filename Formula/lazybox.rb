class Lazybox < Formula
  desc "A reactive PR inbox and agent workspace manager for the terminal."
  homepage "https://lazybox.ai"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.11/lazybox-tui-boot-aarch64-apple-darwin.tar.xz"
      sha256 "d6e8fd9bb2d3a627bf6846a21a676b8a1afbfa783249fd2274d44970de177ae2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.11/lazybox-tui-boot-x86_64-apple-darwin.tar.xz"
      sha256 "9f496a0d222ca90be6af2bee6081bfbd4eba2718bd4f6c582ff702145700e196"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/AntoineToussaint/lazybox/releases/download/v0.1.11/lazybox-tui-boot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5adb6c99898c23ce5b17c850612cbc0b12725908794a502f4efac493bffc730"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
