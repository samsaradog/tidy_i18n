require "i18n"
require "i18n_dev_tools"

RSpec.configure do |config|
  config.before(:each) do
    I18nDevTools.project_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    I18nDevTools.raise_error_on_missing_translation = true

    I18n.load_path = [File.expand_path(File.join(I18nDevTools.project_root, "config", "locales", "en.yml"))]
    I18n.locale = :en
    I18n.default_locale = :en
  end
end
