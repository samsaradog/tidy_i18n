require "spec_helper"
require "tidy_i18n/locales/tilde"

describe TidyI18n::Locales::Tilde do

  def tilde(value)
    TidyI18n::Locales::Tilde.new.convert(value)
  end

  it "wraps a value in tildes" do
    expect(tilde("Some Value")).to eq("~Some Value~")
  end

  it "wraps an interpolated value" do
    expect(tilde("Some %{thing}")).to eq("~Some %{thing}~")
  end

  describe "using the tilde locale" do
    it "translates a simple value" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.reload!
      I18n.locale = :tilde
      expect(TidyI18n.translate("hello_world")).to eq(tilde(I18n.translate("hello_world", :locale => :en)))
    end

    it "translates an interpolated value" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.reload!
      I18n.locale = :tilde
      expect(TidyI18n.translate("hello_person", :name => "Eric")).to eq("~HAI Eric~")
    end

    it "retains the en locale" do
      I18n.load_path << File.join(TidyI18n.project_root, "config", "locales", "auto_generated_locales.rb")
      I18n.reload!
      I18n.locale = :en
      expect(TidyI18n.translate("hello_world")).to eq("HAI WORLD")
      expect(TidyI18n.translate("full.path")).to eq("Localized Full Path")
    end
  end
end
