require 'logger'

require 'iptc/multiple_hash'
require 'iptc/jpeg/marker_headers'

module IPTC
  module JPEG
    class Image
      attr_reader :values
      # creates a JPEG image from a file and does a "quick" load (Only the metadata
      # are loaded, not the whole file).
      def initialize filename, quick=true
        @logger = Logger.new(STDOUT)
        @logger.datetime_format = "%H:%M:%S"
        @logger.level = $DEBUG?(Logger::DEBUG):(Logger::INFO)
      
        @filename = filename
        @position = 0
        @content = File.open(@filename).binmode.read
      
      
        if MARKERS[read(2)]!="SOI"
          raise  NotJPEGFileException.new("Not a JPEG file: #{@filename}")
        end
      
        @markers = Array.new()
      
        begin
      
          catch(:end_of_metadata) do
            while true
              @markers << read_marker
            end
          end
        
        rescue Exception=>e
          @logger.info "Exception in file #{@filename}:\n"+e.to_s
          raise e
        end
        # Markers all read
        # move back
        seek(-2)
      
        # in full mode, read the rest
        if !quick
          @data = read_rest
        end
      
        @values = MultipleHash.new
      
        @markers.each do |marker|
          # puts "processing marker: #{marker.inspect}"
          marker.parse
          # puts marker.valid?
          @values.add(marker, marker.values)
        end
      end
    
      def read(count)
        @position += count
        return @content[@position-count...@position]
      end
      def seek(count)
        @position += count
      end
    
      def l message
        @logger.debug message
      end
    
      # write the image to the disk
      def write filename
        f = File.open(filename,"wb+")
        f.print "\xFF\xD8"
      
        @markers.each do |marker|
          f.print marker.to_binary
        end
        f.print @data.to_binary
        f.close
      
      end
    
      def read_marker
        type = read(2)
        # finished reading all the metadata
        throw :end_of_metadata if MARKERS[type]=='SOS'
        size = read(2)
        data = read(size.unpack('n')[0]-2)
      
        return Marker.NewMarker(MARKERS[type], type+size+data, @logger)
      end
      def read_rest
        rest = @content[@position..-1]
        return Marker.new("BIN",rest)
      end
    
    end
  end
end