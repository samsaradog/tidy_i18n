require "psych"

module TidyI18n
  TranslationKey = Struct.new(:name, :value)
  class TranslationKeys

    def self.parse(yaml)
      new(yaml).keys
    end

    class RepeatKeyBuilder

      attr_reader :parsed_keys

      def initialize
        self.key_parts = []
        self.parsed_keys = []
        self.current_sequence_values = []
      end

      def start_stream(*row); end
      def start_document(*row); end
      def start_sequence(*row)
        self.building_sequence = true
      end

      def start_mapping(*row)
        @most_recent_scalar = nil
      end

      def scalar(*row)
        if second_half_of_pair?
          append_parsed_key(row.first)
        elsif building_sequence?
          current_sequence_values << row.first
        else
          key_parts << row.first
          @most_recent_scalar = row
        end
      end

      def end_mapping(*row)
        @key_parts.pop
      end

      def end_document(*row); end
      def end_stream(*row); end
      def end_sequence
        append_parsed_key(current_sequence_values)
        self.building_sequence = false
        self.current_sequence_values = []
      end

      private

      def append_parsed_key(value)
        parsed_keys << TranslationKey.new(key_parts.join("."), value)
        key_parts.pop
        @most_recent_scalar = nil
      end

      def building_sequence?
        building_sequence
      end

      def second_half_of_pair?
        @most_recent_scalar && !building_sequence?
      end

      attr_accessor :key_parts, :building_sequence, :current_sequence_values
      attr_writer :parsed_keys

    end

    def initialize(yaml)
      self.yaml = yaml
    end

    def keys
      @keys ||= build_keys
    end

    private

    def build_keys
      builder = RepeatKeyBuilder.new
      parser = Psych::Parser.new(builder)
      parser.parse(yaml)
      builder.parsed_keys
    end

    attr_accessor :yaml

  end
end
