require "i18n_dev_tools/dictionary_converter"

require "surrogate/rspec"
module Mocks
  class PhraseConverter

    Surrogate.endow(self)

    define(:convert) { |value| "converted #{value}" }

  end
end

describe I18nDevTools::DictionaryConverter do

  def converted_dictionary(original_dictionary)
    phrase_converter = Mocks::PhraseConverter.factory
    converter = I18nDevTools::DictionaryConverter.new(original_dictionary, phrase_converter)
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

  it "raises an error for an invalid source dictionary" do
    invalid_object = double("invalid object", inspect: "some invalid object")
    expect {
      converted_dictionary({
        foo: invalid_object
      })
    }.to raise_error(/some invalid object/)
  end

end
