# Tidy I18n

[![Build Status](https://travis-ci.org/ericmeyer/tidy_i18n.svg?branch=master)](https://travis-ci.org/ericmeyer/tidy_i18n)

TidyI18n is a gem that wraps the I18n gem. It's purpose is to help you manage your locale files. Features include:

 * Searching locale files for duplicate keys
 * Finding missing keys in a given locale

## Dependencies

 * Ruby
    * .ruby-version file contains the latest version confirmed supported
    * See .travis.yml for more supported versions
 * Bundler

## Usage

`gem install tidy_i18n`

OR

Add `gem "tidy_i18n"` to your Gemfile.

## Setup

1. Clone repo
1. `gem install bundler`
1. `bundle install`

### Running Tests

`rake spec`
