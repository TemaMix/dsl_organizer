lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dsl_organizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'dsl_organizer'
  spec.version       = DslOrganizer::VERSION
  spec.authors       = ['Artem Rumiantcev']
  spec.email         = ['tema.place@gmail.com']

  spec.summary       = 'DSL organizer allows to add flexible' \
                       ' and readable dsl handlers to your project.'
  spec.homepage      = 'http://github.com/TemaMix/dsl_organizer'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host
  # or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files
  # in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
                     .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-auto_inject', '~> 0.6.0'
  spec.add_dependency 'dry-container', '~> 0.7.0'

  spec.add_development_dependency 'bundler', '~> 1.17.2', '>= 1.17.2'
  spec.add_development_dependency 'pry-byebug', '~> 3.6.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.65'
end
