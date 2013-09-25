require "spec_helper"
require "i18n_dev_tools"
require "mocks/view"

describe I18nDevTools do

  before(:each) do
    @mock_view = Mocks::View.new
  end

  describe "translate" do
    context "with no interpolation arguments" do
      it "expands a partial key into a full path" do
        I18nDevTools.translate(".foo").should == I18n.translate("spec.i18n_dev_tools.relative_key_spec.foo")
      end

      it "expands a partial key when called in a different file" do
        @mock_view.simple_relative_translation.should == I18n.translate("spec.mocks.view.simple_translation")
      end

      it "translates a full path without expanding" do
        I18nDevTools.translate("full.path").should == I18n.translate("full.path")
      end

      it "translates UTF 8 values" do
        I18nDevTools.translate("utf_8").should == I18n.translate("utf_8")
      end
    end

    context "with interpolation arguments" do
      it "expands a partial key into a full path" do
        actual_value = I18n.translate("spec.mocks.view.translation_with_interpolation", name: "Eric")
        @mock_view.relative_translation_with_interpolation.should == actual_value
      end

      it "translates a full key without expanding" do
        actual_value = I18n.translate("spec.mocks.view.translation_with_interpolation", name: "Eric")
      end
    end

    context "called indirectly" do
      def indirect_translation(mock_view)
        mock_view.simple_relative_translation
      end

      it "expands the partial key in the full key" do
        indirect_translation(@mock_view).should == @mock_view.simple_relative_translation
      end
    end


  end
end
