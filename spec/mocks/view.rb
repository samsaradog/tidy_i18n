require "i18n"
require "i18n_dev_tools"

module Mocks
  class View

    def simple_relative_translation
      I18nDevTools.translate(".simple_translation")
    end

    def relative_translation_with_interpolation
      I18nDevTools.translate(".translation_with_interpolation", name: "Eric")
    end

    def indirect_translate
      simple_relative_translation
    end

  end
end
