require "spec_helper"
require "tidy_i18n/missing_keys"

describe TidyI18n::MissingKeys do

  it "has the default locale" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    missing_keys.default_locale.should == I18n.default_locale
  end

  it "passes the locale through" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    missing_keys.locale_to_validate.should == "fr"
  end

  it "has no missing keys with no files" do
    missing_keys = TidyI18n::MissingKeys.new("fr", [])
    missing_keys.all.count.should == 0
  end

  it "has one missing key if there is only one key" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("missing_key", :name => "en.foo", :value => "en value")
    ]
    File.stub(:read).with("en.yml").and_return(en_yaml)
    TidyI18n::TranslationKeys.stub(:parse).with(en_yaml).and_return(en_translation_keys)

    fr_yaml = double("fr_yaml")
    fr_translation_keys = []
    File.stub(:read).with("fr.yml").and_return(fr_yaml)
    TidyI18n::TranslationKeys.stub(:parse).with(fr_yaml).and_return(fr_translation_keys)

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    missing_keys.all.count.should == 1
    first_key = missing_keys.all.first
    first_key.name.should == "foo"
    first_key.value_in_default_locale.should == "en value"
  end

  it "does not include a key that is not missing" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("missing_key", :name => "en.foo", :value => "en value one"),
      double("missing_key", :name => "en.bar.baz", :value => "en value two")
    ]
    File.stub(:read).with("en.yml").and_return(en_yaml)
    TidyI18n::TranslationKeys.stub(:parse).with(en_yaml).and_return(en_translation_keys)

    fr_yaml = double("fr_yaml")
    fr_translation_keys = [
      double("missing_key", :name => "fr.foo", :value => "fr value one"),
    ]
    File.stub(:read).with("fr.yml").and_return(fr_yaml)
    TidyI18n::TranslationKeys.stub(:parse).with(fr_yaml).and_return(fr_translation_keys)

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    missing_keys.all.count.should == 1
    first_key = missing_keys.all.first
    first_key.name.should == "bar.baz"
    first_key.value_in_default_locale.should == "en value two"
  end

end