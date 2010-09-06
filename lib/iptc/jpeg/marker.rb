require 'logger'

module IPTC
  module JPEG
      # == Marker
      # A Jpeg marker, generic class used by all others markers
      class Marker
          attr_reader :prefix
          attr_reader :values
        
          @@missing = []
        
          # The NewMarker constructor method.
          # Inspect the object space in order to find something usable later
          def Marker.NewMarker(type,data, logger)
            marker_class = "#{type}Marker"
              if JPEG::Markers.constants.include?(marker_class.to_sym)
                  return JPEG::Markers.const_get(marker_class).new(type, data)
              else
                if !@@missing.include?(type)
                  logger.debug "Marker #{type+"Marker"} not found." if logger!=nil
                  @@missing << type
                end
              end
              return Marker.new(type,data)
          end
        
          def l message
            @logger.debug message
          end

          # binary serialization 
          # transform the marker to its final form
          def to_binary data=nil
              if data!=nil
                  return @type+[data.length+2].pack('n')+data
              else
                  return @original_content
              end
          end

          def initialize(type,data)
              @logger = Logger.new(STDOUT)
              @logger.datetime_format = "%H:%M:%S"
              @logger.level = $DEBUG?(Logger::DEBUG):(Logger::INFO)
    
              @original_content = data
            
              @content = StringIO.new(data)
              @type = @content.read(2)
              @size = @content.read(2).unpack('n')[0]-2
            
              if !valid?
                  raise InvalidBlockException.new("In block #{self.class}: invalid marker\n#{@content.read(20)}")
              end

              @prefix = self.class.to_s
            
              @prefix = @prefix[@prefix.rindex("::")+2..-7]
              if @prefix==""
                  @prefix= 'Marker'
              end

              @values = Hash.new
          end
          def read count
              return @content.read(count)
          end
          def valid?
              return true
          end


          # parse the data
          def parse
              return []
          end

          # returns the available properties for the given tag
          def properties
              return []
          end
      end
    
      # This is not a JPEG file.
      class NotJPEGFileException < Exception; end
    
      # The end of the metadata has occured too early
      class EndOfMetaDataException < Exception; end

      # The block is invalide
      class InvalidBlockException < Exception; end
  end



end