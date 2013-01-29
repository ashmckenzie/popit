# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'popit/version'

Gem::Specification.new do |gem|
  gem.name          = "popit"
  gem.version       = Popit::VERSION
  gem.authors       = ["Ash McKenzie"]
  gem.email         = ["ash@greenworm.com.au"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('faye')
  gem.add_dependency('sinatra')
  gem.add_dependency('thin')
  gem.add_dependency('uuid')
  gem.add_dependency('httparty')
  # gem.add_dependency('trollop')
  # gem.add_dependency('subcommand')

  gem.add_development_dependency('awesome_print')
  gem.add_development_dependency('pry')
end
