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

  def stub_keys(file_name, keys)
    yaml = double(file_name)
    allow(File).to receive(:read).with(file_name).and_return(yaml)
    allow(TidyI18n::TranslationKeys).to receive(:parse).with(yaml).and_return(keys)
  end

  it "has one missing key if there is only one key" do
    stub_keys("en.yml", [
      double("missing_key", name: "en.foo", value: "en value")
    ])
    stub_keys("fr.yml", [])

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    expect(missing_keys.all.count).to eq(1)
    first_key = missing_keys.all.first
    expect(first_key.name).to eq("foo")
    expect(first_key.value_in_default_locale).to eq("en value")
  end

  it "does not include a key that is not missing" do
    stub_keys("en.yml", [
      double("missing_key", name: "en.foo", value: "en value one"),
      double("existing_key", name: "en.bar.baz", value: "en value two")
    ])
    stub_keys("fr.yml", [
      double("existing_key", name: "fr.foo", value: "fr value one"),
    ])

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr.yml"])
    expect(missing_keys.all.count).to eq(1)
    first_key = missing_keys.all.first
    expect(first_key.name).to eq("bar.baz")
    expect(first_key.value_in_default_locale).to eq("en value two")
  end

  it "has no missing keys when the keys exist in multiple files" do
    stub_keys("en.yml", [
      double("Key 1", name: "en.foo.bar", value: "en value 1"),
      double("Key 2", name: "en.foo.baz", value: "en value 2")
    ])
    stub_keys("fr_part_one.yml", [
      double("Key 1", name: "fr.foo.bar", value: "fr value 1"),
    ])
    stub_keys("fr_part_two.yml", [
      double("Key 2", name: "fr.foo.baz", value: "fr value 2")
    ])

    missing_keys = TidyI18n::MissingKeys.new("fr", ["en.yml", "fr_part_one.yml", "fr_part_two.yml"])
    expect(missing_keys.all.map(&:name)).to eq([])
  end

end
