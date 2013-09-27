spec = Gem::Specification.new do |s|
  s.name        = "tidy_i18n"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Meyer"]
  s.email       = ["emeyer@8thlight.com"]
  # s.homepage    = "https://github.com/ericmeyer/tidy_i18n"
  s.summary     = %q{Helpers for I18n}
  s.description = %q{Helpers for I18n}
  # s.rubyforge_project = "tidy_i18n"
  s.files         = Dir.glob('lib/**/*')
  s.require_paths = ["lib"]
  s.add_dependency "i18n"
end
