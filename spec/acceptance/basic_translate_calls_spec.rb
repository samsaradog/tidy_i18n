# encoding: UTF-8
require "spec_helper"
require "tidy_i18n"

describe "Translating value" do

  before(:each) do
    file_paths = ["en.yml", "en_with_unicode.yml"].collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
    I18n.load_path = file_paths
    I18n.available_locales = [:en]
    I18n.locale = :en
  end

  it "works for a basic value" do
    expect(TidyI18n.translate("a.b")).to eq("1")
  end

  it "works for a value with a unicode character" do
    expect(TidyI18n.translate("hello_snowman")).to eq("Hello ☃!")
  end

end
