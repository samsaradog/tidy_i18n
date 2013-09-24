module I18nDevTools
  module Locales
    class Reverse

      INTERPOLATION_SEGMENT=/(%{[^\}]+})/

      def convert(value)
        reverse_interpolation_segments(value).reverse
      end

      private

      def reverse_interpolation_segments(value)
        interpolation_segment_match = value.match(INTERPOLATION_SEGMENT)
        if interpolation_segment_match
          interpolation_segment = interpolation_segment_match[1]
          value.sub!(INTERPOLATION_SEGMENT, interpolation_segment.reverse)
          reverse_interpolation_segments(value)
        end
        value
      end

    end
  end
end
