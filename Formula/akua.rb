# frozen_string_literal: true

# Generated from the verified akua-dev/cli v0.9.0 release manifest.
class Akua < Formula
  desc "CLI for building, deploying, and operating applications with Akua"
  homepage "https://docs.akua.dev"
  version "0.9.0"

  on_macos do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.9.0/akua-v0.9.0-darwin-arm64.tar.gz"
      sha256 "693dd34907ae25624f76dfbf04118677e0a17eb7e929a399c3deaa6d86e338ee"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.9.0/akua-v0.9.0-darwin-x64.tar.gz"
      sha256 "c53a7aa485faff8a67ff3bf7185a4273674440f484b3a9fda5da6d3778cf633a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.9.0/akua-v0.9.0-linux-arm64.tar.gz"
      sha256 "524b421df58e841e9dba03fec2604542fe430af99a13d12c5251dceefba603d7"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.9.0/akua-v0.9.0-linux-x64.tar.gz"
      sha256 "2e218fa0b41a42f6d4179396f8fec7a069ae57f8cb6650d323360ee2a92d0b93"
    end
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"akua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/akua --version")
    if (libexec/"node_modules/@akua-dev/native").exist?
      assert_match '"version"', shell_output("#{bin}/akua pkg version --json")
    else
      assert_match "Usage: akua", shell_output("#{bin}/akua pkg --help")
    end
  end
end
