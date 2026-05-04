# frozen_string_literal: true

# Auto-bumped by cli-release.yml in cnap-tech/akua on every
# tag push. Manual edits get overwritten.
class Akua < Formula
  desc "Cloud-native package build, transform, and preview toolkit"
  homepage "https://github.com/cnap-tech/akua"
  version "0.8.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "fa8236b6cbf773648f33c18ca22a3c511d88efeb10042934b588879d19214044"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "8e20297ee651e816ebaf3f6265578b4f38916bb2b9f2f19ca2b3151cdb6f5f58"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2cce72ae1b30c3eda5dfaf741b8d50846befcab37f34f49967893f30e4b98828"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "896ab54b1fdb60e764a191db459ca9f935a5f2efedb21166cd1daabe4d526820"
    end
  end

  def install
    bin.install "akua"
    doc.install "README.md", "SECURITY.md" if File.exist?("README.md")
  end

  test do
    assert_match(/akua/, shell_output("#{bin}/akua --version"))
  end
end
