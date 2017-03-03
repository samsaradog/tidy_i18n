require "tidy_i18n/translation_keys"
require "ostruct"

module TidyI18n
  class DuplicateKeys

    attr_reader :locale

    def initialize(locale, locale_file_paths)
      self.locale = locale
      self.locale_file_paths = locale_file_paths
    end

    def all
      grouped_keys = translation_keys_for_current_locale.group_by(&:name).values
      grouped_keys.select do |occurrences|
        occurrences.count > 1
      end.collect do |occurrences|
        OpenStruct.new({
          :name => occurrences.first.name.sub(/^#{locale}\./, ""),
          :values => occurrences.collect(&:value)
        })
      end
    end

    private

    def translation_keys_for_current_locale
      all_translation_keys.fetch(locale.to_s, [])
    end

    def all_translation_keys
      locale_file_paths.each.with_object({}) do |locale_file_path, locale_to_keys|
        keys = TidyI18n::TranslationKeys.parse(File.read(locale_file_path))
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

    attr_accessor :locale_file_paths
    attr_writer :locale

  end
end
