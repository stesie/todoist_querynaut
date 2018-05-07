# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "todoist_querynaut"
  spec.version       = '0.1.2'
  spec.authors       = ["Stefan Siegl"]
  spec.email         = ["stesie@brokenpipe.de"]

  spec.summary       = %q{Todoist Query Language implementation}
  spec.description   = %q{Todoist implements its filter and query language client side, this Gem reimplements the language features against Todoist's REST API.}

  spec.homepage      = "https://github.com/stesie/todoist_querynaut"
  spec.license       = "MIT"

  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock", "~> 1.17"

  spec.add_runtime_dependency 'ruby-todoist-api', '~> 0.3'
  spec.add_runtime_dependency 'treetop', '~> 1.5'
end
