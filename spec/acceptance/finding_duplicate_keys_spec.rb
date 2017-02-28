require "spec_helper"
require "tidy_i18n/duplicate_keys"

describe "Finding duplicate translations" do

  it "finds duplicate keys when the locale only has one file" do
    file_paths = ["en_with_duplicate_keys.yml"].collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
    duplicate_keys = TidyI18n::DuplicateKeys.new("en", file_paths)

    expect(duplicate_keys.locale).to eq("en")

    expect(duplicate_keys.all.size).to eq(2)

    first_key = duplicate_keys.all.first
    expect(first_key.name).to eq("a.b")
    expect(first_key.values).to eq(["b1", "b2"])

    second_key = duplicate_keys.all[1]
    expect(second_key.name).to eq("d.f")
    expect(second_key.values).to eq(["f1", "f2"])
  end

end
