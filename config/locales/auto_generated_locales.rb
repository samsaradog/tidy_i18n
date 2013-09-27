require "tidy_i18n/locales"
require "tidy_i18n/locales/reverse"
require "tidy_i18n/locales/tilde"

TidyI18n::Locales.convert(:en, :to => {
  reverse: TidyI18n::Locales::Reverse,
  tilde: TidyI18n::Locales::Tilde
})
