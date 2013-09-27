require "spec_helper"
require "tidy_i18n"

describe "Missing translations" do

  it "raises the missing translation error" do
    TidyI18n.raise_error_on_missing_translation = true
    expect {
      I18n.translate("missing.key")
    }.to raise_error(I18n::MissingTranslationData, /missing.key/)
  end

  it "does not raise an error" do
    TidyI18n.raise_error_on_missing_translation = false
    expect {
      I18n.translate("missing.key")
    }.to_not raise_error
  end

end
