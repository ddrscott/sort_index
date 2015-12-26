# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sort_index/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.0.0'
  spec.name          = 'sort_index'
  spec.version       = SortIndex::VERSION
  spec.authors       = ['Scott Pierce']
  spec.email         = ['ddrscott@gmail.com']

  spec.summary       = %q{Simple File wrapper to keep file contents unique and sorted as lines are added.}
  spec.description   = <<-RDOC
== Description ==
Proof of concept to maintain a file with sorted and unique values.
This could be helpful for building building indexes.

Range#bsearch is used to determine if a line is already in the file and
to determine where a line should be inserted. This means Ruby 2.0 is required.
RDOC
  spec.homepage      = 'https://github.com/ddrscott/sort_index'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
end
