module IPTC


  # a MultipleHash associate a String key, a Marker Object and a String value
  # this object 
  class MultipleHash
    def initialize()
      @internal = Hash.new
    end
    def add marker, hash
       hash.each do |key,value|
        @internal[key] ||= []
        @internal[key] << MultipleHashItem.new(marker,key,value)
      end
    end
    def has_key?(key)
      return @internal.has_key?(key)
    end
    # Returns one or more values for a given key
    # if there is only one value, do not send an array back
    # but send the value instead.
    def [](key)
      if has_key?(key)
        if @internal[key].length == 1
          return @internal[key][0]
        else
          return @internal[key]
        end
      end
    end
    def each
      @internal.each do |key, values|
        values.each do |value|
          yield value
        end
      end
    end
  end

  class MultipleHashItem
    attr_reader :key
    def initialize marker, key, value
      @marker = marker
      @key = key
    end
    def value=(value)
      @marker[@key]=value
    end
    def value
      return @marker[@key]
    end
  end

end