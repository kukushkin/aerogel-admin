# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aerogel/admin/version'

Gem::Specification.new do |spec|
  spec.name          = "aerogel-admin"
  spec.version       = Aerogel::Admin::VERSION
  spec.authors       = ["Alex Kukushkin"]
  spec.email         = ["alex@kukushk.in"]
  spec.description   = %q{Admin panel for aerogel CMS}
  spec.summary       = %q{Admin panel for aerogel CMS}
  spec.homepage      = "https://github.com/kukushkin/aerogel-admin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aerogel-core", "~> 1.4"
  spec.add_dependency "aerogel-forms"
  spec.add_dependency "aerogel-users", "~> 1.4"
  spec.add_dependency "aerogel-media", "~> 1.4"
  spec.add_dependency "aerogel-bootstrap"
  spec.add_dependency "aerogel-font_awesome"


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
