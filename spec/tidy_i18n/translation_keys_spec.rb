require "tidy_i18n/translation_keys"

describe TidyI18n::TranslationKeys do

  it "has no keys for an empty yaml" do
    expect(TidyI18n::TranslationKeys.parse("")).to eq([])
  end

  it "has one key for just the locale" do
    yaml = <<YAML
en:
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(1)
    expect(keys.first.name).to eq("en")
    expect(keys.first.value).to eq("")
  end

  it "has one nested key" do
    yaml = <<YAML
en:
  foo: "Bar"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(1)
    expect(keys.first.name).to eq("en.foo")
    expect(keys.first.value).to eq("Bar")
  end

  it "has two keys at the same level" do
    yaml = <<YAML
en:
  foo: "FOO"
  bar: "BAR"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(2)
    expect(keys.first.name).to eq("en.foo")
    expect(keys.first.value).to eq("FOO")
    expect(keys.last.name).to eq("en.bar")
    expect(keys.last.value).to eq("BAR")
  end

  it "has one key nested mutliple times" do
    yaml = <<YAML
en:
  foo:
    bar:
      baz: "123"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(1)
    expect(keys.first.name).to eq("en.foo.bar.baz")
    expect(keys.first.value).to eq("123")
  end

  it "includes the same key twice" do
    yaml = <<YAML
en:
  foo: Foo1
  foo: Foo2
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(2)
    expect(keys.map(&:name)).to eq(["en.foo", "en.foo"])
    expect(keys.map(&:value)).to eq(["Foo1", "Foo2"])
  end

  describe "Parsing sequences" do
    it "parses the only sequence when it has one element" do
      yaml = <<YAML
en:
  day_names:
    - Monday
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      expect(keys.size).to eq(1)
      expect(keys.first.name).to eq("en.day_names")
      expect(keys.first.value).to eq(["Monday"])
    end

    it "has a sequence followed by another key" do
      yaml = <<YAML
en:
  day_names:
    - Monday
  foo: "Bar"
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      expect(keys.size).to eq(2)
      expect(keys.first.name).to eq("en.day_names")
      expect(keys.first.value).to eq(["Monday"])
      expect(keys.last.name).to eq("en.foo")
      expect(keys.last.value).to eq("Bar")
    end

    it "has a two elements sequence" do
      yaml = <<YAML
en:
  day_names:
    - Monday
    - Tuesday
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      expect(keys.size).to eq(1)
      expect(keys.first.name).to eq("en.day_names")
      expect(keys.first.value).to eq(["Monday", "Tuesday"])
    end

    it "has a two elements sequence followed by another key" do
      yaml = <<YAML
en:
  day_names:
    - Monday
    - Tuesday
  foo: "Bar"
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      expect(keys.size).to eq(2)
      expect(keys.first.name).to eq("en.day_names")
      expect(keys.first.value).to eq(["Monday", "Tuesday"])
      expect(keys.last.name).to eq("en.foo")
      expect(keys.last.value).to eq("Bar")
    end

    it "has a two sibling sequences" do
      yaml = <<YAML
en:
  day_names:
    - Monday
    - Tuesday
  month_names:
    - January
    - February
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      expect(keys.size).to eq(2)
      expect(keys.first.name).to eq("en.day_names")
      expect(keys.first.value).to eq(["Monday", "Tuesday"])
      expect(keys.last.name).to eq("en.month_names")
      expect(keys.last.value).to eq(["January", "February"])
    end
  end

  it "has keys for a complicated example" do
    yaml = <<YAML
en:
  foo:
    bar: 123
    baz: 456
    quo:
      wat: What
      multi:
        - One
        - Two
        - Three
  foo2: Wat
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    expect(keys.size).to eq(5)
    expect(keys.map(&:name)).to contain_exactly(
      "en.foo.bar",
      "en.foo.baz",
      "en.foo.quo.wat",
      "en.foo2",
      "en.foo.quo.multi"
    )
  end

end
