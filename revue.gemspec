# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'revue/version'

Gem::Specification.new do |spec|
  spec.name          = "revue"
  spec.version       = Revue::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tubbo@psychedeli.ca"]

  spec.summary       = %q{Finally, proper Stash synchronization for JIRA.}
  spec.description   = %q{Finally, proper Stash synchronization for JIRA. Because Atlassian couldn't figure this out.}
  spec.homepage      = "http://github.com/tubbo/revue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"

  spec.add_dependency 'jira-ruby'
  spec.add_dependency 'stash-client'
  spec.add_dependency 'activemodel'
end
