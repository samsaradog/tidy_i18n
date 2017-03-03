require "spec_helper"
require "tidy_i18n/duplicate_keys"

describe "Finding duplicate translations" do

  def locale_file_paths(file_names)
    file_names.collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
  end

  it "finds duplicate keys when the locale only has one file" do
    duplicate_keys = TidyI18n::DuplicateKeys.new("en", locale_file_paths(["en_with_duplicate_keys.yml"]))

    expect(duplicate_keys.locale).to eq("en")

    expect(duplicate_keys.all.size).to eq(2)

    first_key = duplicate_keys.all.first
    expect(first_key.name).to eq("a.b")
    expect(first_key.values).to eq(["b1", "b2"])

    second_key = duplicate_keys.all[1]
    expect(second_key.name).to eq("d.f")
    expect(second_key.values).to eq(["f1", "f2"])
  end

  it "finds duplicate keys when the locale is split has multiple files" do
    file_paths = locale_file_paths(["en_with_duplicate_keys.yml", "en_with_more_duplicates.yml"])
    duplicate_keys = TidyI18n::DuplicateKeys.new("en", file_paths)

    expect(duplicate_keys.locale).to eq("en")

    duplicate_key_names = duplicate_keys.all.map(&:name)
    expect(duplicate_key_names).to contain_exactly("a.b", "d.f", "c", "d.e")
  end

end
