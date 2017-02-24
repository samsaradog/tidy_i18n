require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

task :default => :spec

RSpec::Core::RakeTask.new(:travis) do |task|
  task.verbose = false
  task.rspec_opts = "--format documentation --color"
end

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

task :find_duplicate_keys, [:locale] => :load_i18n do |t, args|
  require "hirb"
  require "tidy_i18n/duplicate_keys"
  locale = args.locale
  duplicate_keys = TidyI18n::DuplicateKeys.new(locale, I18n.load_path)
  puts "Finding duplicate keys for \"#{locale}\""
  duplicate_key_hashes = duplicate_keys.all.collect do |duplicate_key|
    {
      :name => duplicate_key.name,
      :values => duplicate_key.values
    }
  end
  puts Hirb::Helpers::Table.render duplicate_key_hashes,
                                   :fields => [:name, :values],
                                   :headers => {
                                     :name => "Translation Key",
                                     :values => "Values"
                                   }
end

desc "Running the example rake tasks"
task :examples do
  puts "************ find_missing_keys   ************"
  Rake::Task[:find_missing_keys].invoke("fr")
  puts "\n\n"
  puts "************ find_duplicate_keys ************"
  Rake::Task[:find_duplicate_keys].invoke("es_with_duplicates")
end
