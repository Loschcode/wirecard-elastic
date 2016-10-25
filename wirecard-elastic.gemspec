# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wirecard/elastic/version'

Gem::Specification.new do |spec|
  spec.name          = "wirecard-elastic"
  spec.version       = Wirecard::Elastic::VERSION
  spec.authors       = ["Loschcode"]
  spec.email         = ["laurent.schaffner.code@gmail.com"]

  spec.summary       = "Wirecard support for Elastic Api"
  spec.description   = "Wirecard support for Elastic Api"
  spec.homepage      = "https://github.com/Loschcode/wirecard-elastic"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport"

end
