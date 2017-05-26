# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'xcode-readme'
  spec.version       = '0.1.0'
  spec.authors       = ["dkhamsing"]
  spec.email         = ["dkhamsing8@gmail.com"]

  spec.summary       = 'Correct capitalization of Xcode in a README'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/dkhamsing/xcode-readme'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = [spec.name]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'github-readme', '~> 0.1.0.pre'
end
