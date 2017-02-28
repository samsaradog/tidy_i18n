require "spec_helper"
require "tidy_i18n/missing_keys"

describe TidyI18n::MissingKeys do

  it "has the default locale" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    expect(missing_keys.default_locale).to eq(I18n.default_locale)
  end

  it "passes the locale through" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    expect(missing_keys.locale_to_validate).to eq("fr")
  end

  it "has no missing keys with no files" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    expect(missing_keys.all.count).to eq(0)
  end

  it "has one missing key if there is only one key" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("missing_key", :name => "en.foo", :value => "en value")
    ]
    allow(File).to receive(:read).with("en.yml").and_return(en_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_yaml).and_return(en_translation_keys)

    fr_yaml = double("fr_yaml")
    fr_translation_keys = []
    allow(File).to receive(:read).with("fr.yml").and_return(fr_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(fr_yaml).and_return(fr_translation_keys)

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    expect(missing_keys.all.count).to eq(1)
    first_key = missing_keys.all.first
    expect(first_key.name).to eq("foo")
    expect(first_key.value_in_default_locale).to eq("en value")
  end

  it "does not include a key that is not missing" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("missing_key", :name => "en.foo", :value => "en value one"),
      double("missing_key", :name => "en.bar.baz", :value => "en value two")
    ]
    allow(File).to receive(:read).with("en.yml").and_return(en_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_yaml).and_return(en_translation_keys)

    fr_yaml = double("fr_yaml")
    fr_translation_keys = [
      double("missing_key", :name => "fr.foo", :value => "fr value one"),
    ]
    allow(File).to receive(:read).with("fr.yml").and_return(fr_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(fr_yaml).and_return(fr_translation_keys)

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    expect(missing_keys.all.count).to eq(1)
    first_key = missing_keys.all.first
    expect(first_key.name).to eq("bar.baz")
    expect(first_key.value_in_default_locale).to eq("en value two")
  end

end
