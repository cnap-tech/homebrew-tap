# frozen_string_literal: true

# Generated from the verified akua-dev/cli v0.10.0 release manifest.
class Akua < Formula
  desc "CLI for building, deploying, and operating applications with Akua"
  homepage "https://docs.akua.dev"
  version "0.10.0"

  on_macos do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.0/akua-v0.10.0-darwin-arm64.tar.gz"
      sha256 "f63397fd6778c4716df185be06968289fc34264aed2d0336c7500018010b8108"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.0/akua-v0.10.0-darwin-x64.tar.gz"
      sha256 "fd92211676981270cfb181c5e9f9261899404f7958a4444af23e138bb68928e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.0/akua-v0.10.0-linux-arm64.tar.gz"
      sha256 "fb7ef9285bfdf7131a41c2b7e51093c8df468331fab4c5606ec6b70a750528ce"
    end
    on_intel do
      url "https://github.com/akua-dev/cli/releases/download/v0.10.0/akua-v0.10.0-linux-x64.tar.gz"
      sha256 "6191ca66568cfe51b063672fae712a9b6dc57330b4984b1c5b28bbc311ad02ed"
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
