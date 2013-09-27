require "tidy_i18n/dictionary_converter"

module TidyI18n
  module Locales

    def self.convert(source_locale, options)
      keys_to_locale_classes = options.fetch(:to)
      keys_to_locale_classes.each_with_object({}) do |(key, locale_class), hash|
        converter = TidyI18n::DictionaryConverter.new(
          TidyI18n::Translations.for_locale(source_locale),
          locale_class.new
        )
        hash[key] = converter.converted_dictionary
      end
    end

  end
end