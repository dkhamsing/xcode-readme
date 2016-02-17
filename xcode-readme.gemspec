# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-readme/constants'

Gem::Specification.new do |spec|
  spec.name          = CocoapodsReadme::PRODUCT
  spec.version       = CocoapodsReadme::VERSION
  spec.authors       = ["dkhamsing"]
  spec.email         = ["dkhamsing8@gmail.com"]

  spec.summary       = CocoapodsReadme::PRODUCT_DESCRIPTION
  spec.description   = CocoapodsReadme::PRODUCT_DESCRIPTION
  spec.homepage      = CocoapodsReadme::PRODUCT_URL

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = [CocoapodsReadme::PRODUCT, CocoapodsReadme::BATCH]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'octokit', '~> 4.2.0' #github
  spec.add_dependency 'differ', '~> 0.1.2'
end
