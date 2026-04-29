# frozen_string_literal: true

# Auto-bumped by cli-release.yml in cnap-tech/akua on every
# tag push. Manual edits get overwritten.
class Akua < Formula
  desc "Cloud-native package build, transform, and preview toolkit"
  homepage "https://github.com/cnap-tech/akua"
  version "0.8.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "949ab196a31c9804c96b24d597111629557cf0a7ab9bbecabec120f35f659e96"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d72e6d1b5468c739a0bb24477591c6f8c8d71266890f5ff93fd8442e0ba71c63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60cd68197d000e0342a7d0c0bf8f16c2ec88f29136105e70d1551d8cd7beeeaf"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2df8a4cc59d3831a945c637a80af362ce17963321307cfefea3139911730da73"
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
