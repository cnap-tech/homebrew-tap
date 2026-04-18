# frozen_string_literal: true

# Homebrew formula for akua — cloud-native package build and
# transform toolkit. Installs the prebuilt binary from the official
# GitHub Release (no from-source build).
#
# Auto-bumped by the cli-release.yml workflow in cnap-tech/akua via
# `mislav/bump-homebrew-formula-action@v3`; manual edits here will be
# overwritten on the next tag push.
class Akua < Formula
  desc "Cloud-native package build, transform, and preview toolkit"
  homepage "https://github.com/cnap-tech/akua"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "72f41c4b0ac4f98a78655d7541636e444c9be3186657683402a71332e7c1d63f"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "c43a80f510f13c550ddaaad9e5c92174810b09eb6ed1848212ea7c8ee6ac69bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60ab3e279b6c71c7a72fef948e779927d9e15d55f5801d0f35258e290f881cc0"
    end
    on_intel do
      url "https://github.com/cnap-tech/akua/releases/download/akua-v#{version}/akua-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b292e72948d41a5ba9fe7cd601a8136c828bf28b8d52043bfab0b65c9165eb0a"
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
