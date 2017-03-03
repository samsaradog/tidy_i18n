require "spec_helper"
require "tidy_i18n/duplicate_keys"

describe TidyI18n::DuplicateKeys do

  def duplicate_keys(locale, locale_file_paths)
    TidyI18n::DuplicateKeys.new(locale, locale_file_paths)
  end

  it "has the locale" do
    expect(duplicate_keys("en", []).locale).to eq("en")
  end

  it "has no duplicate keys for no files" do
    expect(duplicate_keys("en", []).all).to eq([])
  end

  it "has one duplicate key for the only key" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("key occurence 1", :name => "en.foo", :value => "value 1"),
      double("key occurence 2", :name => "en.foo", :value => "value 2")
    ]
    allow(File).to receive(:read).with("en.yml").and_return(en_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_yaml).and_return(en_translation_keys)

    keys = duplicate_keys("en", ["en.yml"]).all
    expect(keys.count).to eq(1)
    expect(keys.first.name).to eq("foo")
    expect(keys.first.values).to contain_exactly("value 1", "value 2")
  end

  it "has one duplicate key when only one is duplicated" do
    en_yaml = double("en_yaml")
    en_translation_keys = [
      double("key occurence 1", :name => "en.foo", :value => "value 1"),
      double("other key", :name => "en.bar", :value => "other vale"),
      double("key occurence 2", :name => "en.foo", :value => "value 2")
    ]
    allow(File).to receive(:read).with("en.yml").and_return(en_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_yaml).and_return(en_translation_keys)

    keys = duplicate_keys("en", ["en.yml"]).all
    expect(keys.count).to eq(1)
  end

  it "has one duplicate key when only one is duplicated" do
    en_part_one_yaml = double("en_part_one_yaml")
    en_part_one_translation_keys = [
      double("key occurence 1", :name => "en.foo", :value => "value 1"),
    ]
    allow(File).to receive(:read).with("en_part_one.yml").and_return(en_part_one_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_part_one_yaml).and_return(en_part_one_translation_keys)

    en_part_two_yaml = double("en_part_two_yaml")
    en_part_two_translation_keys = [
      double("key occurence 2", :name => "en.foo", :value => "value 2"),
    ]
    allow(File).to receive(:read).with("en_part_two.yml").and_return(en_part_two_yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(en_part_two_yaml).and_return(en_part_two_translation_keys)

    keys = duplicate_keys("en", ["en_part_one.yml", "en_part_two.yml"]).all
    expect(keys.count).to eq(1)
    expect(keys.first.name).to eq("foo")
    expect(keys.first.values).to contain_exactly("value 1", "value 2")
  end

end
