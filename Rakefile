require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


task :load_i18n do
  $: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))
  require "i18n"
  I18n.load_path += Dir.glob("config/locales/**/*.yml")
end

task :find_missing_keys, [:locale] => :load_i18n do |t, args|
  require "hirb"
  require "tidy_i18n/missing_keys"
  default_locale = I18n.default_locale
  locale_to_validate = args.locale
  missing_keys = TidyI18n::MissingKeys.new(locale_to_validate, I18n.load_path)
  puts "Finding missing keys for \"#{locale_to_validate}\""
  missing_key_hashes = missing_keys.all.collect do |missing_key|
    {
      :name => missing_key.name,
      :value_in_default_locale => missing_key.value_in_default_locale
    }
  end
  puts Hirb::Helpers::Table.render missing_key_hashes,
                                   :fields => [:name, :value_in_default_locale],
                                   :headers => {
                                     :name => "Translation Key",
                                     :value_in_default_locale => "\"#{default_locale}\" value"
                                   }
end
