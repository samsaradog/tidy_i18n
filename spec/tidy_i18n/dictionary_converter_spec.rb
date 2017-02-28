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
    expect(converted_dictionary({})).to eq({})
  end

  it "converts one key" do
    expect(converted_dictionary({
      "foo" => "bar"
    })).to eq({
      "foo" => "converted bar"
    })
  end

  it "converts two keys at the top level" do
    expect(converted_dictionary({
      "foo1" => "bar1",
      "foo2" => "bar2"
    })).to eq({
      "foo1" => "converted bar1",
      "foo2" => "converted bar2"
    })
  end

  it "converts a nested key" do
    expect(converted_dictionary({
      "foo" => {
        "bar" => "baz"
      }
    })).to eq({
      "foo" => {
        "bar" => "converted baz"
      }
    })
  end

  it "works with symbols" do
    expect(converted_dictionary({
      foo: {
        bar: "baz"
      }
    })).to eq({
      foo: {
        bar: "converted baz"
      }
    })
  end

  it "converts a complicated example" do
    expect(converted_dictionary({
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
    })).to eq({
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
    })
  end

  it "converts an Array" do
    expect(converted_dictionary({
      "foo" => ["bar1", "bar2"]
    })).to eq({
      "foo" => ["converted bar1", "converted bar2"]
    })
  end

  it "leaves an Integer unchanged" do
    expect(converted_dictionary({
      "foo" => 5,
      "bar" => [1, 2, 3]
    })).to eq({
      "foo" => 5,
      "bar" => [1, 2, 3]
    })
  end

  it "leaves bools unchanged" do
    expect(converted_dictionary({
      "foo" => false,
      "bar" => [true, false, true]
    })).to eq({
      "foo" => false,
      "bar" => [true, false, true]
    })
  end

  it "leaves nil unchanged" do
    expect(converted_dictionary({
      "foo" => nil,
      "bar" => [nil]
    })).to eq({
      "foo" => nil,
      "bar" => [nil]
    })
  end

  it "leaves symbols unchanged" do
    expect(converted_dictionary({
      "foo" => :wat,
      "bar" => [:baz, :quo]
    })).to eq({
      "foo" => :wat,
      "bar" => [:baz, :quo]
    })
  end

end
