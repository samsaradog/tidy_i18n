require "spec_helper"
require "i18n_dev_tools"

describe "Missing translations" do

  it "raises the missing translation error" do
    I18nDevTools.raise_error_on_missing_translation = true
    expect {
      I18n.translate("missing.key")
    }.to raise_error(I18n::MissingTranslationData, /missing.key/)
  end

  it "does not raise an error" do
    I18nDevTools.raise_error_on_missing_translation = false
    expect {
      I18n.translate("missing.key")
    }.to_not raise_error
  end

end
