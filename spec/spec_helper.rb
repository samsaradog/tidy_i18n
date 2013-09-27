require "i18n"
require "tidy_i18n"

RSpec.configure do |config|
  config.before(:each) do
    TidyI18n.project_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    TidyI18n.raise_error_on_missing_translation = true

    I18n.load_path = [File.expand_path(File.join(TidyI18n.project_root, "config", "locales", "en.yml"))]
    I18n.locale = :en
    I18n.default_locale = :en
  end
end
