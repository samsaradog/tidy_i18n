Rspec.configure do |config|
  config.before(:each) do
    I18nDevTools.project_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    I18n.load_path << File.expand_path(File.join(I18nDevTools.project_root, "config", "locales", "en.yml"))
    I18n.locale = :en
  end
end
