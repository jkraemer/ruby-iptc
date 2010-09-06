require 'stringio'

require 'iptc/marker'
require 'iptc/marker_nomenclature'
require 'iptc/jpeg/marker'

module IPTC

  module JPEG
      # == Markers
      # All the known JPEG markers
      module Markers
          # == SOIMarker
          # The Start Of Image Marker
      	class SOIMarker < Marker
      	    def valid?
      	        return read(5)=="JFIF\0"
      	    end
          end
          # == APP1Marker
          # The APP1 Marker, Exif container
          class APP1Marker < Marker
              def valid?
                xap = 'http://ns.adobe.com/xap/1.0/'
                header = read(xap.size)
                return header == xap || header.start_with?("Exif\0\0")
              end
          end
          # == COMMarker
          # The COM Marker, contains comments
          class COMMarker < Marker
              attr_reader :content
              def parse
                  l "COM Marker Parsed"
                  @content = read(@size)
                  @dirty = false

                  @values['COM/COM']=@content
              end
  #            def []=(key,value)
  #                if @content != value
  #                    @content = value
  #                    @dirty = true
  #                end
  #            end
              def [](item)
                  return @content
              end
          end
          # == The APP13Marker
          # The APP13 marker, know as the IPTC Marker
          # See also the IPTC::MarkerNomenclature.
          class APP13Marker < Marker
              def initialize(type, data)
                  @header = "Photoshop 3.0\0008BIM"

                  super(type, data)
                  @prefix = "iptc"

              end
              def valid?
                  return read(@header.length)==@header
              end
            
              def parse
                l "APP13 marker parsed"
                @markers = Array.new	    
              

                @bim_type = read(2)
                @bim_dummy = read(4)
                size = read(2)

                content = StringIO.new(read(size.unpack('n')[0]))

                while !content.eof?
                  
                  header = content.read(2)

                  # http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/IPTC.html
                  case header
                  when "\x1c\x01"
                    # skip the envelope
                    while !content.eof?
                      if content.read(1) == "\x1c"
                        content.pos = content.pos - 1
                        break
                      end
                    end
                  when "\x1c\x02"
                
                    type = content.read(1).unpack('c')[0]
                    size = content.read(2)
                    value = content.read(size.unpack('n')[0])

                    l "Found marker #{type}"
                    marker = IPTC::Marker.new(type, value)
                    @values[@prefix+"/"+IPTC::MarkerNomenclature.markers(type.to_i).name] ||= []
                    @values[@prefix+"/"+IPTC::MarkerNomenclature.markers(type.to_i).name] << value
                    @markers << marker

                  else
                    # raise InvalidBlockException.new("Invalid BIM segment #{header.inspect} in marker\n#{@original_content.inspect}")
                  end
                end
                return @values
              end
            
              def [](item)
                  return @values[item]
              end
              def to_binary
                  marker = ""
                  @markers.each do |value|
                      marker += value.to_binary
                  end
                
                  marker =  @header+@bim_type+@bim_dummy+[marker.length].pack('n')+marker

                  # build the complete marker
                  marker = super(marker)
                
                  return marker
              end
              def properties
                  return IPTC::TAGS.values.sort
              end
              def set(property, value)
                  numerical_tag = IPTC::TAGS.index(property)
                      if numerical_tag!=nil
                  else
                      throw InvalidPropertyException.new("Invalid property #{property} for IPTC marker")
                  end
                  marker = IPTC::Marker.new(numerical_tag, value)
                  @markers << marker
              end
          end
          class InvalidPropertyException < Exception
          end
          # == The APP0Marker
          # Contains some useful JFIF informations about the current
          # image.
          class APP0Marker < Marker
              def initialize type, data 
                  super type, data
              end
              def valid?
                  if read(5)!="JFIF\0"
                      return false
                  end
                  return true
              end
              def parse

                  @values = {
                      'APP1/revision'=>read(2).unpack('n')[0],
                      'APP1/unit' => read(1),
                      'APP1/xdensity' => read(2).unpack('n')[0],
                      'APP1/ydensity' => read(2).unpack('n')[0],
                      'APP1/xthumbnail' => read(1).unpack('c')[0],
                      'APP1/ythumbnail' => read(1).unpack('c')[0]
                  }
              end
              def [](item)
                  return @values[item]
              end
          end
  	end
  end
end

if $0 == __FILE__
    if ARGV[0]==nil
      puts "No file given. Aborting."
      exit
    end
    
    require 'iptc/jpeg/image'
    

    # read the image
    im = IPTC::JPEG::Image.new(ARGV[0])

    puts "Done reading #{ARGV[0]}"

    im.values.each do |item|
        puts "#{item.key}\t#{item.value}"
    end
  
end
