# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-genhashvalue"
  spec.version       = "0.04"
  spec.authors       = ["m.takemi"]
  spec.email         = ["m.takemi@gmail.com"]

  spec.summary       = %q{generate hash value}
  spec.description   = %q{generate hash(md5/sha1/sha256/sha512) value}
  spec.homepage      = "https://qos.dev7.net/~masafumi/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "fluentd", "~> 0.12"
  spec.add_runtime_dependency "base91", '>= 0.0.1'
end
