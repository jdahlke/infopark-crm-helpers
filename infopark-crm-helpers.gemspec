# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crm/helpers/version'

rails_version = ENV['TRAVIS_RAILS_VERSION'].to_s
rails_version = rails_version.empty? ? '>= 5.0' : "~> #{rails_version}.0"

Gem::Specification.new do |spec|
  spec.name = 'infopark-crm-helpers'
  spec.version = Crm::Helpers::VERSION
  spec.authors = ['Huy Dinh']
  spec.email = ['mail@huydinh.eu']

  spec.summary = 'Helpers for the Infopark WebCRM SDK for Ruby.'
  spec.description = 'infopark-crm-helpers provides helper mixins and ' \
                     'validators to use with the Infopark WebCRM.' \
                     'It is based on the Infopark WebCRM SDK for Ruby.'
  spec.homepage = 'https://github.com/Skudo/infopark-crm-helpers'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'activemodel', rails_version
  spec.add_dependency 'activesupport', rails_version
  spec.add_dependency 'infopark_webcrm_sdk'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
