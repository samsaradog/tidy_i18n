require "spec_helper"
require "tidy_i18n/locales/reverse"

describe TidyI18n::Locales::Reverse do

  def reverse(value)
    TidyI18n::Locales::Reverse.new.convert(value)
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

  it "leaves the original string unaltered" do
    # reverse("ABC %{foo} DEF %{bar}").should == "%{bar} FED %{foo} CBA"
    # foo = "%{paint_system_name} - %{paint_system_type}"
    original_string = "ABC"
    reverse(original_string)
    original_string.should == "ABC"
  end

  it "reverses a two interpolation string" do
    reverse("%{foo} - %{bar}").should == "%{bar} - %{foo}"
  end

  describe "using the reverse locale" do
    it "translates a simple value" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.reload!
      I18n.locale = :reverse
      TidyI18n.translate("hello_world").should == reverse(I18n.translate("hello_world", :locale => :en))
      TidyI18n.translate("hello_person", :name => "Eric").should == "Eric IAH"
    end
  end
end
