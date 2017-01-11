# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parse/stack/async/version'

Gem::Specification.new do |spec|
  spec.name          = "parse-stack-async"
  spec.version       = Parse::Stack::Async::VERSION
  spec.authors       = ["Anthony Persaud"]
  spec.email         = ["persaud@modernistik.com"]

  spec.summary       = %q{Parse Server operations asynchronously.}
  spec.description   = %q{Perform Parse Server operations asynchronously. This is a plugin to the Parse Stack that allows for CRUD operations to be done in a background thread.}
  spec.homepage      = "https://github.com/modernistik/parse-stack-async"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "parse-stack", ['~> 1', '>= 1.6']
  spec.add_runtime_dependency "sucker_punch", '~> 2'
end

## Development
# After checking out the repo, run `bin/setup` to install dependencies. You can 
# also run `bin/console` for an interactive prompt that will allow you to experiment.
#
# To install this gem onto your local machine, run `bundle exec rake install`.
# To release a new version, update the version number in `version.rb`, and then run
# `bundle exec rake release`, which will create a git tag for the version,
# push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
