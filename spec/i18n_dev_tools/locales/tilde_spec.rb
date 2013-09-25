require "spec_helper"
require "i18n_dev_tools/locales/tilde"

describe I18nDevTools::Locales::Tilde do

  def tilde(value)
    I18nDevTools::Locales::Tilde.new.convert(value)
  end

  it "wraps a value in tildes" do
    tilde("Some Value").should == "~Some Value~"
  end

  describe "using the tilde locale" do
    it "translates a simple value" do
      I18n.load_path << File.join(I18nDevTools.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.locale = :tilde
      I18nDevTools.translate("hello_world").should == tilde(I18n.translate("hello_world", :locale => :en))
    end
  end
end
