# typed: strict
# frozen_string_literal: true

require "json"
require "optparse"
require "tempfile"

# Validates a published CLI Homebrew manifest and renders Formula/akua.rb.
module CliFormula
  PLATFORMS = {
    "macos_arm"   => ["darwin-arm64", "on_macos", "on_arm"],
    "macos_intel" => ["darwin-x64", "on_macos", "on_intel"],
    "linux_arm"   => ["linux-arm64", "on_linux", "on_arm"],
    "linux_intel" => ["linux-x64", "on_linux", "on_intel"],
  }.freeze
  MANIFEST_KEYS = %w[formula platforms release schema_version version].freeze
  PLATFORM_KEYS = %w[artifact sha256 url].freeze
  VERSION_PATTERN = /\A\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?\z/
  SHA256_PATTERN = /\A[0-9a-f]{64}\z/

  module_function

  def update(options)
    manifest = JSON.parse(File.read(options.fetch(:manifest)))
    validate_manifest(manifest, options)
    write_atomically(options.fetch(:output), render(manifest))
  end

  def validate_manifest(manifest, options)
    require_hash(manifest, "manifest")
    require_keys(manifest, MANIFEST_KEYS, "manifest")

    version = options.fetch(:version)
    raise ArgumentError, "version is not valid SemVer" unless VERSION_PATTERN.match?(version)
    raise ArgumentError, "tag must equal v#{version}" if options.fetch(:tag) != "v#{version}"

    release_url = "https://github.com/akua-dev/cli/releases/tag/v#{version}"
    manifest_url = "https://github.com/akua-dev/cli/releases/download/v#{version}/akua-v#{version}-homebrew.json"
    if options.fetch(:release_url) != release_url
      raise ArgumentError,
            "release URL does not match the verified release"
    end
    if options.fetch(:manifest_url) != manifest_url
      raise ArgumentError,
            "manifest URL does not match the verified release"
    end
    raise ArgumentError, "manifest.schema_version must equal 1" if manifest.fetch("schema_version") != 1
    raise ArgumentError, "manifest.formula must equal akua" if manifest.fetch("formula") != "akua"
    if manifest.fetch("version") != version
      raise ArgumentError,
            "manifest.version does not match dispatch version"
    end
    if manifest.fetch("release") != release_url
      raise ArgumentError,
            "manifest.release does not match dispatch release"
    end

    platforms = manifest.fetch("platforms")
    require_hash(platforms, "manifest.platforms")
    require_keys(platforms, PLATFORMS.keys, "manifest.platforms")
    PLATFORMS.each do |name, (target, _os, _arch)|
      release = platforms.fetch(name)
      require_hash(release, name.to_s)
      require_keys(release, PLATFORM_KEYS, name)
      artifact = "akua-v#{version}-#{target}.tar.gz"
      url = "https://github.com/akua-dev/cli/releases/download/v#{version}/#{artifact}"
      if release.fetch("artifact") != artifact
        raise ArgumentError,
              "#{name}.artifact does not match the release target"
      end
      if release.fetch("url") != url
        raise ArgumentError,
              "#{name}.url does not match the verified release"
      end
      sha256 = release.fetch("sha256")
      raise ArgumentError, "#{name}.sha256 is invalid" unless sha256.is_a?(String)
      raise ArgumentError, "#{name}.sha256 is invalid" unless SHA256_PATTERN.match?(sha256)
    end
  end

  def render(manifest)
    version = manifest.fetch("version")
    platforms = manifest.fetch("platforms")
    <<~RUBY
      # frozen_string_literal: true

      # Generated from the verified akua-dev/cli v#{version} release manifest.
      class Akua < Formula
        desc "CLI for building, deploying, and operating applications with Akua"
        homepage "https://docs.akua.dev"
        version "#{version}"

      #{render_os("on_macos", platforms)}

      #{render_os("on_linux", platforms)}

        def install
          libexec.install Dir["*"]
          bin.install_symlink libexec/"akua"
        end

        test do
          assert_match version.to_s, shell_output("\#{bin}/akua --version")
          if (libexec/"node_modules/@akua-dev/native").exist?
            assert_match '"version"', shell_output("\#{bin}/akua pkg version --json")
          else
            assert_match "Usage: akua", shell_output("\#{bin}/akua pkg --help")
          end
        end
      end
    RUBY
  end

  def render_os(os_block, platforms)
    entries = PLATFORMS.select { |_name, (_target, os, _arch)| os == os_block }
    lines = ["  #{os_block} do"]
    entries.each do |name, (_target, _os, arch_block)|
      release = platforms.fetch(name)
      lines.push(
        "    #{arch_block} do",
        "      url \"#{release.fetch("url")}\"",
        "      sha256 \"#{release.fetch("sha256")}\"",
        "    end",
      )
    end
    lines << "  end"
    lines.join("\n")
  end

  def require_hash(value, field)
    raise ArgumentError, "#{field} must be an object" unless value.is_a?(Hash)
  end

  def require_keys(value, expected, field)
    actual = value.keys.sort
    return if actual == expected.sort

    raise ArgumentError, "#{field} keys must be exactly: #{expected.sort.join(", ")}"
  end

  def write_atomically(output, contents)
    directory = File.dirname(File.expand_path(output))
    temporary = nil
    temporary = Tempfile.new(["akua-formula-", ".rb"], directory)
    temporary.write(contents)
    temporary.close
    File.rename(temporary.path, output)
  ensure
    temporary.close! if temporary && File.exist?(temporary.path)
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  parser = OptionParser.new do |arguments|
    arguments.banner = "Usage: update_formula.rb [options]"
    arguments.on("--version VERSION") { |value| options[:version] = value }
    arguments.on("--tag TAG") { |value| options[:tag] = value }
    arguments.on("--release-url URL") { |value| options[:release_url] = value }
    arguments.on("--manifest-url URL") { |value| options[:manifest_url] = value }
    arguments.on("--manifest PATH") { |value| options[:manifest] = value }
    arguments.on("--output PATH") { |value| options[:output] = value }
  end

  begin
    parser.parse!
    required = [:version, :tag, :release_url, :manifest_url, :manifest, :output]
    missing = required.reject { |name| options.key?(name) }
    raise OptionParser::MissingArgument, missing.join(", ") unless missing.empty?

    CliFormula.update(options)
  rescue JSON::ParserError, KeyError, ArgumentError, OptionParser::ParseError => e
    warn "Formula update rejected: #{e.message}"
    exit 1
  end
end
