require "spec_helper"
require "tidy_i18n"
require "mocks/view"

describe TidyI18n do

  before(:each) do
    @mock_view = Mocks::View.new
  end

  describe "translate" do
    context "with no interpolation arguments" do
      it "expands a partial key into a full path" do
        expect(TidyI18n.translate(".foo")).to eq(I18n.translate("spec.tidy_i18n.relative_key_spec.foo"))
      end

      it "expands a partial key when called in a different file" do
        expect(@mock_view.simple_relative_translation).to eq(I18n.translate("spec.mocks.view.simple_translation"))
      end

      it "translates a full path without expanding" do
        expect(TidyI18n.translate("full.path")).to eq(I18n.translate("full.path"))
      end

      it "translates UTF 8 values" do
        expect(TidyI18n.translate("utf_8")).to eq(I18n.translate("utf_8"))
      end
    end

    context "with interpolation arguments" do
      it "expands a partial key into a full path" do
        actual_value = I18n.translate("spec.mocks.view.translation_with_interpolation", name: "Eric")
        expect(@mock_view.relative_translation_with_interpolation).to eq(actual_value)
      end

      it "translates a full key without expanding" do
        actual_value = I18n.translate("spec.mocks.view.translation_with_interpolation", name: "Eric")
        expect(TidyI18n.translate("spec.mocks.view.translation_with_interpolation", name: "Eric")).to eq(actual_value)
      end
    end

    context "called indirectly" do
      def indirect_translation(mock_view)
        mock_view.simple_relative_translation
      end

      it "expands the partial key in the full key" do
        expect(indirect_translation(@mock_view)).to eq(@mock_view.simple_relative_translation)
      end
    end

    it "also works by calling just 't'" do
      expect(TidyI18n.t(".foo")).to eq(TidyI18n.translate(".foo"))
    end
  end

end
