require "i18n"
require "tidy_i18n/translation_keys"
require "ostruct"

module TidyI18n
  class MissingKeys

    attr_reader :locale_to_validate

    def initialize(locale_to_validate, locale_files)
      self.locale_to_validate = locale_to_validate
      self.locale_files = locale_files
    end

    def default_locale
      I18n.default_locale
    end

    def all
      default_locale_keys = translation_keys_for_locale(default_locale)
      locale_to_validate_keys = translation_keys_for_locale(locale_to_validate)
      default_locale_keys.each.with_object([]) do |key_in_default_locale, keys|
        if !locale_to_validate_key_names.include?(key_in_default_locale.name)
          keys << OpenStruct.new({
            :name => key_in_default_locale.name,
            :value_in_default_locale => key_in_default_locale.value
          })
        end
      end
    end

    private

    def locale_to_validate_key_names
      @locale_to_validate_key_names ||= translation_keys_for_locale(locale_to_validate).map(&:name)
    end

    def translation_keys_for_locale(locale)
      all_translation_keys.fetch(locale.to_s, [])
    end

    def all_translation_keys
      locale_files.each.with_object({}) do |locale_file, locale_to_keys|
        keys = TidyI18n::TranslationKeys.parse(File.read(locale_file))
        if keys.any?
          current_locale = keys.first.name.split(".").first
          previous_keys = locale_to_keys.fetch(current_locale.to_s, [])
          locale_to_keys[current_locale.to_s] = previous_keys + keys.collect do |key|
            OpenStruct.new({
              :name => key.name.sub(/^#{current_locale}\./, ""),
              :value => key.value
            })
          end
        end
      end
    end

    attr_writer :locale_to_validate
    attr_accessor :locale_files

  end
end
