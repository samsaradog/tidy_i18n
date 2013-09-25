require "i18n_dev_tools/locales"
require "i18n_dev_tools/locales/reverse"
require "i18n_dev_tools/locales/tilde"

I18nDevTools::Locales.build({
  reverse: I18nDevTools::Locales::Reverse,
  tilde: I18nDevTools::Locales::Tilde
})
