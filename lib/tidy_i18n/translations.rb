require "i18n"
require "i18n/backend/simple"

module TidyI18n
  class Translations

    def self.for_locale(locale)
      Marshal.load(Marshal.dump(::I18n.backend.send(:translations)[locale]))
    end

  end
end
