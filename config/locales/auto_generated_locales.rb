require "i18n_dev_tools/locales"
require "i18n_dev_tools/locales/reverse"

I18nDevTools::Locales.build({
  reverse: I18nDevTools::Locales::Reverse
})
