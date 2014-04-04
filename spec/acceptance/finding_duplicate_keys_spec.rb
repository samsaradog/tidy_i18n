require "spec_helper"
require "tidy_i18n/duplicate_keys"

describe "Finding duplicate translations" do

  it "finds duplicate keys when the locale only has one file" do
    file_paths = ["en_with_duplicate_keys.yml"].collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
    duplicate_keys = TidyI18n::DuplicateKeys.new("en", file_paths)

    duplicate_keys.locale.should == "en"

    duplicate_keys.all.size.should == 2

    first_key = duplicate_keys.all.first
    first_key.name.should == "a.b"
    first_key.values.should =~ ["b1", "b2"]

    second_key = duplicate_keys.all[1]
    second_key.name.should == "d.f"
    second_key.values.should =~ ["f1", "f2"]
  end

end
