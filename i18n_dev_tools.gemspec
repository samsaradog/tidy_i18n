spec = Gem::Specification.new do |s|
  s.name        = "i18n_dev_tools"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Meyer"]
  s.email       = ["emeyer@8thlight.com"]
  # s.homepage    = "https://github.com/ericmeyer/i18n_dev_tools"
  s.summary     = %q{Helpers for I18n}
  s.description = %q{Helpers for I18n}
  # s.rubyforge_project = "i18n_dev_tools"
  s.files         = Dir.glob('lib/**/*')
  s.require_paths = ["lib"]
end
