require "spec_helper"
require "tidy_i18n/missing_keys"

describe "Finding missing translations" do

  it "finds missing keys when each locale has only one file" do
    file_paths = ["en.yml", "fr_with_missing_keys.yml"].collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
    missing_keys = TidyI18n::MissingKeys.new("fr", file_paths)

    expect(missing_keys.locale_to_validate).to eq("fr")
    expect(missing_keys.default_locale).to eq(I18n.default_locale)

    expect(missing_keys.all.size).to eq(2)

    first_key = missing_keys.all.first
    expect(first_key.name).to eq("c")
    expect(first_key.value_in_default_locale).to eq("2")

    second_key = missing_keys.all[1]
    expect(second_key.name).to eq("d.f")
    expect(second_key.value_in_default_locale).to eq("4")
  end

end
