require "i18n_dev_tools/translations"

module I18nDevTools
  class DictionaryConverter

    class InvalidTranslationValue < StandardError
    end

    def initialize(dictionary, locale)
      self.dictionary = dictionary
      self.locale = locale
    end

    def converted_dictionary
      convert(dictionary)
    end

    private

    def convert(dictionary)
      dictionary.each_with_object({}) do |(key, value), new_dictionary|
        case value.class.name
        when "String"
          new_dictionary[key] = locale.convert(value)
        when "Hash"
          new_dictionary[key] = convert(value)
        else
          raise InvalidTranslationValue.new(value.inspect)
        end
      end
    end

    attr_accessor :dictionary, :locale

  end
end
