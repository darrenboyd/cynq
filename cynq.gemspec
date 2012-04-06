# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cynq/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Darren Boyd"]
  gem.email         = ["dboyd@realgravity.com"]
  gem.description   = %q{Easy synchronization of local files to cloud based storage.}
  gem.summary       = %q{Copy files to the cloud.}
  gem.homepage      = "https://github.com/darrenboyd/cynq"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cynq"
  gem.require_paths = ["lib"]
  gem.version       = Cynq::VERSION

  gem.add_dependency 'fog', '~> 1.1'
  gem.add_dependency 'colorize', '~> 0.5'
end
