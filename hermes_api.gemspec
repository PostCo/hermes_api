# frozen_string_literal: true

require_relative "lib/hermes_api/version"

Gem::Specification.new do |spec|
  spec.name = "hermes_api"
  spec.version = HermesAPI::VERSION
  spec.authors = ["Andy Chong"]
  spec.email = ["andy@postco.co"]

  spec.summary = "Unofficial Ruby object based Hermes UK API wrapper."
  spec.description = "Unofficial Ruby object based Hermes UK API wrapper."
  spec.homepage = "https://github.com/PostCo/hermes_api"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PostCo/hermes_api"
  spec.metadata["changelog_uri"] = "https://github.com/PostCo/hermes_api/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activeresource", ">= 4.1.0"
  spec.add_dependency "rexml", "~> 3.2", ">= 3.2.4"

  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "zeitwerk"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
