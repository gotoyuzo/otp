module OTP
  module Base32
    ENCODE_CHARS = %w(
      A B C D E F G H I J K L M N O P
      Q R S T U V W X Y Z 2 3 4 5 6 7
    )

    DECODE_MAP = {
      "A"=>0,  "B"=>1,  "C"=>2,  "D"=>3,  "E"=>4,  "F"=>5,  "G"=>6,  "H"=>7,
      "I"=>8,  "J"=>9,  "K"=>10, "L"=>11, "M"=>12, "N"=>13, "O"=>14, "P"=>15,
      "Q"=>16, "R"=>17, "S"=>18, "T"=>19, "U"=>20, "V"=>21, "W"=>22, "X"=>23,
      "Y"=>24, "Z"=>25, "2"=>26, "3"=>27, "4"=>28, "5"=>29, "6"=>30, "7"=>31,
      "0"=>14, "1"=>11, "8"=>1,                        # mistyped chars
      " "=>-2, "-"=>-2, "\n"=>-2, "\r"=>-2, "\t"=>-2,  # separators
      "="=>-1,                                         # padding
    }

    module_function

    def encode(bytes)
      return nil unless bytes
      bytes = bytes.dup.force_encoding("binary")
      ret = ""
      offset = buffer = buffered = 0
      while offset < bytes.length
        buffer = ((buffer << 8) | bytes[offset].ord)
        buffered += 8
        offset += 1
        while buffered >= 5
          ret << ENCODE_CHARS[buffer >> (buffered - 5)]
          buffered -= 5
          buffer &= (0xff >> (8 - buffered))
        end
      end
      if buffered > 0
        ret << ENCODE_CHARS[buffer << (5 - buffered)]
      end
      return ret
    end

    def padding(str)
      return str + "=" * (-str.length % 8)
    end

    def decode(chars)
      return nil unless chars
      ret = "".force_encoding("binary")
      chars = chars.upcase
      buffer = buffered = 0
      chars.each_char do |c|
        d = DECODE_MAP[c]
        raise ArgumentError, "invalid char: #{c}" if d.nil?
        next if d == -2
        break if d == -1
        buffer = (buffer << 5) | d
        buffered += 5
        next if buffered < 8
        ret << ((buffer >> (buffered - 8)) & 0xff)
        buffered -= 8
      end
      return ret
    end

    alias encode32 encode
    alias decode32 decode
  end
end
