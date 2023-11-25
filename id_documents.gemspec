# frozen_string_literal: true

require_relative "lib/id_documents/version"

Gem::Specification.new do |spec|
  spec.name = "id_documents"
  spec.version = IDDocuments::VERSION
  spec.authors = ["Ziyan Junaideen"]
  spec.email = ["ziyan@jdeen.com"]

  spec.summary = "ID Document validator and metadata extractor."
  spec.description = <<-DESC
    id_documents is a Ruby library for validating and extracting meta data from ID documents.
  DESC
  spec.homepage = "https://github.com/ziyan-junaideen/id_documents"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ziyan-junaideen/id_documents"
  spec.metadata["changelog_uri"] = "https://github.com/ziyan-junaideen/id_documents/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "artii", "~> 2.1"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
