# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crm/helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'infopark-crm-helpers'
  spec.version       = Crm::Helpers::VERSION
  spec.authors       = ['Huy Dinh']
  spec.email         = ['mail@huydinh.eu']

  spec.summary       = 'Helpers for the Infopark WebCRM SDK for Ruby.'
  spec.description   = 'infopark-crm-helpers provides helper mixins and validators to use with the Infopark WebCRM. It is based on the Infopark WebCRM SDK for Ruby.'
  spec.homepage      = 'https://github.com/Skudo/infopark-crm-helpers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'infopark_webcrm_sdk'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
