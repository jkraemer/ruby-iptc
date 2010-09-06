module IPTC
  # == Marker
  # A simple IPTC Marker
  class Marker
      attr_accessor :value
      def initialize(type, value)
          @type = type
          @value = value
      end
      def to_s
          self.value
      end
      def to_binary
          "\x1c\x02"+[@type, @value.length].pack('cn')+@value
      end        
  end
end
  