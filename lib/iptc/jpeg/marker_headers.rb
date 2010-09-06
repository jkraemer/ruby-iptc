module IPTC
  module JPEG
      MARKERS = {
          "\xFF\xD8" => 'SOI',
          "\xFF\xc0" => 'SOF0',
          "\xFF\xc1" => 'SOF1',
          "\xFF\xc2" => 'SOF2',
          "\xFF\xc3" => 'SOF3',

          "\xFF\xc5" => 'SOF5',
          "\xFF\xc6" => 'SOF6',
          "\xFF\xc7" => 'SOF7',

          "\xFF\xc8" => 'JPG',
          "\xFF\xc9" => 'SOF9',
          "\xFF\xca" => 'SOF10',
          "\xFF\xcb" => 'SOF11',

          "\xFF\xcd" => 'SOF13',
          "\xFF\xce" => 'SOF14',
          "\xFF\xcf" => 'SOF15',

          "\xFF\xc4" => 'DHT',

          "\xFF\xcc" => 'DAC',

          "\xFF\xd0" => 'RST0',
          "\xFF\xd1" => 'RST1',
          "\xFF\xd2" => 'RST2',
          "\xFF\xd3" => 'RST3',
          "\xFF\xd4" => 'RST4',
          "\xFF\xd5" => 'RST5',
          "\xFF\xd6" => 'RST6',
          "\xFF\xd7" => 'RST7',

          "\xFF\xd8" => 'SOI',
          "\xFF\xd9" => 'EOI',
          "\xFF\xda" => 'SOS',
          "\xFF\xdb" => 'DQT',
          "\xFF\xdc" => 'DNL',
          "\xFF\xdd" => 'DRI',
          "\xFF\xde" => 'DHP',
          "\xFF\xdf" => 'EXP',

          "\xFF\xe0" => 'APP0',
          "\xFF\xe1" => 'APP1',
          "\xFF\xe2" => 'APP2',
          "\xFF\xe3" => 'APP3',
          "\xFF\xe4" => 'APP4',
          "\xFF\xe5" => 'APP5',
          "\xFF\xe6" => 'APP6',
          "\xFF\xe7" => 'APP7',
          "\xFF\xe8" => 'APP8',
          "\xFF\xe9" => 'APP9',
          "\xFF\xea" => 'APP10',
          "\xFF\xeb" => 'APP11',
          "\xFF\xec" => 'APP12',
          "\xFF\xed" => 'APP13',
          "\xFF\xee" => 'APP14',
          "\xFF\xef" => 'APP15',
          "\xFF\xf0" => 'JPG0',
          "\xFF\xfd" => 'JPG13',
          "\xFF\xfe" => 'COM',
          "\xFF\x01" => 'TEM'
      }
  end
end