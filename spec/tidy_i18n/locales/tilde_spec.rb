require "spec_helper"
require "tidy_i18n/locales/tilde"

describe TidyI18n::Locales::Tilde do

  def tilde(value)
    TidyI18n::Locales::Tilde.new.convert(value)
  end

  it "wraps a value in tildes" do
    tilde("Some Value").should == "~Some Value~"
  end

  describe "using the tilde locale" do
    it "translates a simple value" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.locale = :tilde
      TidyI18n.translate("hello_world").should == tilde(I18n.translate("hello_world", :locale => :en))
    end
  end
end
