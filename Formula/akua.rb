# frozen_string_literal: true

# Generated from the verified akua-dev/cli v0.10.1 release manifest.
class Akua < Formula
  desc "CLI for building, deploying, and operating applications with Akua"
  homepage "https://docs.akua.dev"
  version "0.10.1"

  on_macos do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.1/akua-v0.10.1-darwin-arm64.tar.gz"
      sha256 "ac35ded63e1f5718ed10a9236cdeaa5d5abf12147cb53b8735b10d6b3acdc800"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.1/akua-v0.10.1-darwin-x64.tar.gz"
      sha256 "33a8618de24e6174935a63e2e8c8091126486b9610c092a8c453a9348e8656b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.1/akua-v0.10.1-linux-arm64.tar.gz"
      sha256 "432d40e4b18fce44e407e5c2fecc9dc062755258edb55bfa7ad8c509241cdbd5"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.1/akua-v0.10.1-linux-x64.tar.gz"
      sha256 "450c67db2fa2e254abae4e15294ab875b8d87a6e124928e362afeb65736d7939"
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
