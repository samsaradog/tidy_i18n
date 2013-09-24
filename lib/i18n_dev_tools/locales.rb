require "i18n_dev_tools/dictionary_converter"

module I18nDevTools
  module Locales

    def self.build(keys_to_locale_classes)
      keys_to_locale_classes.each_with_object({}) do |(key, locale_class), hash|
        converter = I18nDevTools::DictionaryConverter.new(
          I18nDevTools::Translations.for_locale(I18n.default_locale),
          locale_class.new
        )
        hash[key] = converter.converted_dictionary
      end
    end

  end
end