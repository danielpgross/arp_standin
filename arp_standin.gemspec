# frozen_string_literal: true

require_relative "lib/arp_standin/version"

Gem::Specification.new do |spec|
  spec.name = "arp_standin"
  spec.version = ArpStandin::VERSION
  spec.authors = ["Daniel P. Gross"]
  spec.email = ["daniel@dgross.ca"]

  spec.summary = "Respond to ARP requests on behalf of another machine. Useful for keeping a sleeping machine accessible on the network."
  spec.homepage = "https://github.com/danielpgross/arp_standin"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/danielpgross/arp_standin"
  spec.metadata["changelog_uri"] = "https://github.com/danielpgross/arp_standin/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["arp_standin"]
  spec.require_paths = ["lib"]

  spec.add_dependency "pcaprub", "~> 0.13"
  spec.add_dependency "packetfu", "~> 1.1"
end
