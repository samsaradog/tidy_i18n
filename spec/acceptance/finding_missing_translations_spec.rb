require "spec_helper"
require "tidy_i18n/missing_keys"

describe "Finding missing translations" do

  it "finds missing keys when each locale has only one file" do
    file_paths = ["en.yml", "fr_with_missing_keys.yml"].collect do |path|
      File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path))
    end
    missing_keys = TidyI18n::MissingKeys.new("fr", file_paths)

    missing_keys.locale_to_validate.should == "fr"
    missing_keys.default_locale.should == I18n.default_locale

    missing_keys.all.size.should == 2

    first_key = missing_keys.all.first
    first_key.name.should == "c"
    first_key.value_in_default_locale.should == "2"

    second_key = missing_keys.all[1]
    second_key.name.should == "d.f"
    second_key.value_in_default_locale.should == "4"
  end

end
