require "spec_helper"
require "tidy_i18n/locales/reverse"

describe TidyI18n::Locales::Reverse do

  def reverse(value)
    TidyI18n::Locales::Reverse.new.convert(value)
  end

  before(:each) do
    I18n.available_locales << :reverse
  end

  it "reverses input with no interpolation" do
    expect(reverse("Some Value")).to eq("eulaV emoS")
  end

  it "does not reverse one interpolated value" do
    expect(reverse("ABC %{foo} DEF")).to eq("FED %{foo} CBA")
  end

  it "does not reverse two interpolated values" do
    expect(reverse("ABC %{foo} DEF %{bar}")).to eq("%{bar} FED %{foo} CBA")
  end

  it "leaves the original string unaltered" do
    original_string = "ABC"
    reverse(original_string)
    expect(original_string).to eq("ABC")
  end

  it "reverses a two interpolation string" do
    expect(reverse("%{foo} - %{bar}")).to eq("%{bar} - %{foo}")
  end

  describe "using the reverse locale" do
    it "translates a simple value" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.reload!
      I18n.locale = :reverse
      expect(TidyI18n.translate("hello_world")).to eq(reverse(I18n.translate("hello_world", :locale => :en)))
      expect(TidyI18n.translate("hello_person", :name => "Eric")).to eq("Eric IAH")
    end
  end
end
