require "spec_helper"
require "i18n_dev_tools/locales/reverse"

describe I18nDevTools::Locales::Reverse do

  def reverse(value)
    I18nDevTools::Locales::Reverse.new.convert(value)
  end

  it "reverses input with no interpolation" do
    reverse("Some Value").should == "eulaV emoS"
  end

  it "does not reverse one interpolated value" do
    reverse("ABC %{foo} DEF").should == "FED %{foo} CBA"
  end

  it "does not reverse two interpolated values" do
    reverse("ABC %{foo} DEF %{bar}").should == "%{bar} FED %{foo} CBA"
  end

  it "works" do
    reverse("ABC %{foo} DEF GHI").should == "IHG FED %{foo} CBA"
  end

  describe "using the reverse locale" do
    xit "translates a simple value" do
      # I18nDevTools.enable_test_translation(:reverse, I18nDevTools::Locales::Reverse)
      I18n.load_path << File.join(I18nDevTools.project_root, "config", "locales", "auto_generated_translations.rb")
      I18n.locale = :reverse
      I18nDevTools.translate("hello_world").should == reverse(I18n.translate("hello_world", :locale => :en))
    end
  end
end
