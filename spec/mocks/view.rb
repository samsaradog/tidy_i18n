require "i18n"
require "tidy_i18n"

module Mocks
  class View

    def simple_relative_translation
      TidyI18n.translate(".simple_translation")
    end

    def relative_translation_with_interpolation
      TidyI18n.translate(".translation_with_interpolation", name: "Eric")
    end

    def indirect_translate
      simple_relative_translation
    end

  end
end
