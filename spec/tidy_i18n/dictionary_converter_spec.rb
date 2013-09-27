# encoding: UTF-8
require "tidy_i18n/dictionary_converter"

require "surrogate/rspec"
module Mocks
  class PhraseConverter

    Surrogate.endow(self)

    define(:convert) { |value| "converted #{value}" }

  end
end

describe TidyI18n::DictionaryConverter do

  def converted_dictionary(original_dictionary)
    phrase_converter = Mocks::PhraseConverter.factory
    converter = TidyI18n::DictionaryConverter.new(original_dictionary, phrase_converter)
    converter.converted_dictionary
  end

  it "converts an empty dictionary" do
    converted_dictionary({}).should == {}
  end

  it "converts one key" do
    converted_dictionary({
      "foo" => "bar"
    }).should == {
      "foo" => "converted bar"
    }
  end

  it "converts two keys at the top level" do
    converted_dictionary({
      "foo1" => "bar1",
      "foo2" => "bar2"
    }).should == {
      "foo1" => "converted bar1",
      "foo2" => "converted bar2"
    }
  end

  it "converts a nested key" do
    converted_dictionary({
      "foo" => {
        "bar" => "baz"
      }
    }).should == {
      "foo" => {
        "bar" => "converted baz"
      }
    }
  end

  it "works with symbols" do
    converted_dictionary({
      foo: {
        bar: "baz"
      }
    }).should == {
      foo: {
        bar: "converted baz"
      }
    }
  end

  it "converts a complicated example" do
    converted_dictionary({
      a1: {
        b1: {
          c1: "c1 value",
          c2: "c2 value"
        },
        b2: "b2 value",
        b3: "b3 value"
      },
      a2: "a2 value",
      a3: {
        b1: {
          c1: {
            d1: "d1 value",
            d2: "d2 value"
          }
        }
      }
    }).should == {
      a1: {
        b1: {
          c1: "converted c1 value",
          c2: "converted c2 value"
        },
        b2: "converted b2 value",
        b3: "converted b3 value"
      },
      a2: "converted a2 value",
      a3: {
        b1: {
          c1: {
            d1: "converted d1 value",
            d2: "converted d2 value"
          }
        }
      }
    }
  end

  it "converts an Array" do
    converted_dictionary({
      "foo" => ["bar1", "bar2"]
    }).should == {
      "foo" => ["converted bar1", "converted bar2"]
    }
  end

  it "leaves a Fixnum unchanged" do
    converted_dictionary({
      "foo" => 5,
      "bar" => [1, 2, 3]
    }).should == {
      "foo" => 5,
      "bar" => [1, 2, 3]
    }
  end

  it "leaves bools unchanged" do
    converted_dictionary({
      "foo" => false,
      "bar" => [true, false, true]
    }).should == {
      "foo" => false,
      "bar" => [true, false, true]
    }
  end

  it "leaves a Fixnum unchanged" do
    converted_dictionary({
      "foo" => 5,
      "bar" => [1, 2, 3]
    }).should == {
      "foo" => 5,
      "bar" => [1, 2, 3]
    }
  end

  it "leaves a nil unchanged" do
    converted_dictionary({
      "foo" => nil,
      "bar" => [nil]
    }).should == {
      "foo" => nil,
      "bar" => [nil]
    }
  end

  it "leaves symbols unchanged" do
    converted_dictionary({
      "foo" => :wat,
      "bar" => [:baz, :quo]
    }).should == {
      "foo" => :wat,
      "bar" => [:baz, :quo]
    }
  end

end
