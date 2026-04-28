# frozen_string_literal: true

# Auto-bumped by cli-release.yml in cnap-tech/akua on every
# tag push. Manual edits get overwritten.
class Akua < Formula
  desc "Cloud-native package build, transform, and preview toolkit"
  homepage "https://github.com/cnap-tech/akua"
  version "0.7.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b44ffdd603933d4aa490b8765fd55b58804f11d63e8a223a5a4d87fb16c11eb8"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "1b17a8165902233c5c3e124ed797f1c3d3f7f7795809de5064ce1e2b9ee75208"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1f40549bcd7aa95bf6a0bdf9f37b2a9c3973486841c7312f836be9be14cb7d56"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53b05eda1fca33d54d117d86b94719d187e3d3dbfec9d11815305c38679e2fe4"
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
