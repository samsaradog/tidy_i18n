require "i18n"
require "i18n/backend/simple"

module I18nDevTools
  class Translations

    def self.for_locale(locale)
      ::I18n.backend.send(:translations)[locale]
    end

  end
end
