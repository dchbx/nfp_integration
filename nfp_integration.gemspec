# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


Gem::Specification.new do |spec|
  spec.name        = 'nfp_integration'
  spec.version     = '0.0.10'
  spec.date        = '2017-09-26'
  spec.summary     = "SOAP Request Gem for NFP"
  spec.description = "Manage NFP SOAP Requests"
  spec.authors     = ["Antonio Schaffert"]
  spec.email       = 'antonio.schaffert@gmail.com'
  spec.homepage    = "https://github.com/dchbx"
  spec.bindir        = "exe"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_runtime_dependency "nokogiri", ["~> 1.6"]

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency 'byebug'

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rails"
end
