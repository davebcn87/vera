# frozen_string_literal: true

require_relative 'lib/vera/version'

Gem::Specification.new do |spec|
  spec.name          = 'vera'
  spec.version       = Vera::VERSION
  spec.authors       = ['David Cortés']
  spec.email         = ['david.cortes.18@gmail.com']

  spec.summary       = 'CLI tool to organize and manage media files'
  spec.description   = 'Vera helps you automatize the process of organizing, cleaning and sorting your photo and video files.'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')
  spec.homepage      = 'https://github.com/davebcn87/vera'

  spec.require_paths = ['lib']

  spec.add_dependency 'commander'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.7'

  spec.files         = Dir['./**/*'].reject { |file| file =~ %r{\./(bin|log|pkg|script|spec|test|vendor)} }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
end
